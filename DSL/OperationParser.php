<?php

namespace App\Util;

use Exception;
use App\Exceptions\CalculateException;
use Illuminate\Support\Facades\Lang;
use Illuminate\Support\Facades\DB;
use App\Util\ShuttleLink;

class OperationParser{
    public array $operators=['+', '-', '*', '/', '^'];
    public array $bracket=['(', ')'];
    public array $variable_bracket = ['[', ']'];

    public string $year_month;
    private array $relative_info_array;
    private array $definited;
    private array $functions;
    private array $calc_fields;
    private array $string_fields;
    private array $super_info_array;
    public array $error_messages = [];
    public bool $error_flag = false;
    public array $current_index;
    public array $operated_result = [];
    public ShuttleLink $array_key_stack;
    public array $current_index_stack = [];
    public array $configuration = [];
    
    public array $relative_info_array_definited_stack = [];
    public function __construct(array $relative_info_array, array $definited, array $calc_fields, array $super_info_array, array $string_fields=[], string $array_key='') {
        $this->relative_info_array = $relative_info_array;
        $this->definited = $definited;
        $this->calc_fields = $calc_fields;
        $this->string_fields = $string_fields;
        $this->super_info_array = $super_info_array;
        $this->year_month = $this->definited['year_month'];
        $this->functions = [
            'ROUND' => 1
        ];

        if(strlen($array_key)!=0) {
            $this->array_key_stack = new ShuttleLink('%');
            $array_key_list = preg_split('/\./', $array_key);
            $this->configuration = Lang::get('configurations');
            foreach($array_key_list as $key) {
                $this->array_key_stack->push($key);
            }
            
        }
    }
    public function make_messagebox(): string{
        $messageBox = '';
        foreach($this->error_messages as $index => $message) {
            $messageBox .= $message . '<br />';
        }
        return $messageBox;
    }
    public function parse_all():array{
        foreach($this->relative_info_array as $r_index => $items){
            foreach($this->calc_fields as $index => $field){
                $this->current_index = [$r_index, $field];
                if(array_key_exists($field, $items)){
                    $content = $items[$field];
                    array_push($this->operated_result, 'parse_all: '.$content . PHP_EOL);
                    if(str_starts_with($field, 'sql_')){
                        $this->parse_sql_prefix($content);
                    } else if(str_starts_with($field, 's_')) {
                        $this->parse_string($content);
                    } else {
                        $this->parse_operation($content);
                    }

                }
            }

            if(count($this->string_fields) == 0){
                continue;
            }
            foreach($this->string_fields as $index => $field){
                $this->current_index = [$r_index, $field];
                if(array_key_exists($field, $items)) {
                    $content = $items[$field];
                    $this->parse_string($content);
                }
            }
        }
        return $this->relative_info_array;
    }

    public function parse_operation(string|null $operation, bool $is_global=false):string{
        array_push($this->operated_result, 'parse_operation: '.$operation.PHP_EOL);
        // echo 'parse_operation: '.$operation.PHP_EOL;
        $is_string = false;
        if($operation == null) {
            $this->relative_info_array[$this->current_index[0]][$this->current_index[1]] = 0;
            return '';
        }
        if(is_numeric($operation)) {
            return $operation;
        }
        $operators=['+', '-', '*', '/', '^', '>', '<', '=', '>=', '<=', '<>', '|', '&'];
        $bracket=['(', ')'];
        $variable_bracket = ['[', ']'];
        $operation_arr = str_split($operation);
        $separated_operation_arr = [];
        $item='';
        $bracket_count = 0;

        $index = 0;
        try{
            while($index < count($operation_arr)){
                
                $char = $operation_arr[$index];
                if($char == '(') {
                    $bracket_count++;

                    // サブ演算式、正負表現
                    $item = '';
                    $index++;
                    // 中身
                    for(;$index < count($operation_arr); $index++){
                        $char = $operation_arr[$index];
                        if($char == ' ') {
                            continue;
                        }
                        // 下級サブ演算式、カッコのまま付ける
                        if($char == '('){
                            $bracket_count++;
                        }

                        if($char != ')') {
                            $item .= $char;
                        } else {
                            $bracket_count--;
                            if($bracket_count != 0) {
                                $item .= $char;
                            } else {
                                if(!preg_match("/^(\+|-)/", $item)) {
                                    // サブ演算式
                                    $item = $this->parse_operation($item);
                                }
                                // 他は正負表現
                                array_push($separated_operation_arr, $item);
                                $item = '';
                                $index++;
                                break;
                            }
                        }
                    }
                    if($bracket_count != 0) {
                        throw new CalculateException($operation . '、左右カッコ対称していない');
                    }
                    if($index >= count($operation_arr)) {
                        break;
                    } else {
                        $char = $operation_arr[$index];
                    }
                }
                if(preg_match("/^[a-zA-Z]/", $char)) {
                    // 関数
                    $item = '';
                    $item .= $char;
                    $index++;
                    for(;$index < count($operation_arr);$index++){
                        $char = $operation_arr[$index];
                        $item .= $char;
                        if($char == '(') {
                            $bracket_count++;
                        }

                        if($char == ")") {
                            $bracket_count--;
                            if($bracket_count == 0) {
                                $item = $this->parse_function($item); 
                                array_push($separated_operation_arr, $item);
                                $item = '';
                                $index++;
                                break;
                            }
                        }
                    }
                    if($index >= count($operation_arr)) {
                        break;
                    } else {
                        $char = $operation_arr[$index];
                    }
                }


                if($char == '{'){
                    // 変数、グローバル変数、sql変数
                    $item = '';
                    $index++;
                    // 中身
                    for(;$index < count($operation_arr) ; $index++){
                        $char = $operation_arr[$index];
                        if($char != "}") {
                            $item .= $char;
                        } else {
                            if(str_contains($item, '$.s_')||str_contains($item, '$s_')) {
                                $is_string = true;
                            }
                            $item = $this->parse_variable($item);
                            
                            if($is_string){
                                if(!$is_global){
                                    // 値付け
                                    $this->relative_info_array[$this->current_index[0]][$this->current_index[1]] = $item;
                                }
                                return $item;
                            }
                            array_push($separated_operation_arr, $item);
                            $item = '';
                            $index++;
                            break;
                        }
                    }

                    if($index >= count($operation_arr)) {
                        break;
                    } else {
                        $char = $operation_arr[$index];
                    }
                }

                if($char == '_' && strlen($item) == 0){
                    $item .= $char;
                    $index++;
                    for(;$index<count($operation_arr);$index++){
                        $char = $operation_arr[$index];
                        if(is_numeric($char)){
                            $item .= $char;
                        } else {
                            $item = $this->parse_sql($item);
                            array_push($separated_operation_arr, $item);
                            $item = '';
                            break;
                        }
                        

                    }
                    if($index >= count($operation_arr)) {
                        $item = $this->parse_sql($item);
                        array_push($separated_operation_arr, $item);
                        $item = '';
                        break;
                    }
                }

                if(is_numeric($char)){
                    // 数字、sql表現文123{1.xx, xx}
                    $item .= $char;
                    $index++;
                    // 数字結尾の演算式
                    if($index == count($operation_arr)){
                        array_push($separated_operation_arr, $item);
                        $item = '';
                        break;
                    }
                    for(;$index < count($operation_arr); ){
                        $char = $operation_arr[$index];
                        if(is_numeric($char)|| $char == '.') {
                            $item .= $char;
                            $index++;
                            if($index >= count($operation_arr)) {
                                array_push($separated_operation_arr, $item);
                                $item = '';
                                $index++;
                                break;
                            }
                        }
                        
                        if (in_array($char, $operators)){
                            array_push($separated_operation_arr, $item);
                            break;
                        }
                        if ($char == '{'){
                            // sql文表現
                            $item .= $char;
                            $index++;
                            for(;$index < count($operation_arr); $index++) {
                                $char = $operation_arr[$index];
                                $item .= $char;
                                if($char == '}') {
                                    $item = $this->parse_sql($item);
                                    array_push($separated_operation_arr, $item);
                                    $item = '';
                                    $index++;
                                    break;
                                }
                            }
                            break;
                        }
                    }
                    
                    if($index >= count($operation_arr)) {
                        break;
                    } else {
                        $char = $operation_arr[$index];
                    }
                }


                if(in_array($char, $operators)) {
                    $item = $char;
                    if(in_array($item, ['<', '>', '='])){
                        $temp_next = $operation_arr[$index+1];
                        if(in_array($temp_next, ['>', '<', '='])){
                            $item .= $temp_next;
                            $index++;
                        }
                    }
                    array_push($separated_operation_arr, $item);

                    $item = '';
                    $index++;
                    if($index >= count($operation_arr)){
                        break;
                    } else {
                        $char = $operation_arr[$index];
                    }
                }


            }

            $result = $this->calculate($separated_operation_arr);
            array_push($this->operated_result, ($this->current_index[0]+1).'.'.$this->current_index[1].', '.$operation . ', calculate result: '. $result.PHP_EOL);
            // echo ($this->current_index[0]+1).'.'.$this->current_index[1].', '.$operation . ', calculate result: '. $result.PHP_EOL;
            if(!$is_global){
                // 値付け
                $this->relative_info_array[$this->current_index[0]][$this->current_index[1]] = $result;
            }
            return $result;

        }catch(Exception $e) {
            $this->error_flag = true;
            array_push($this->error_messages, Lang::get('validation.operation_error', [
                'key' => ($this->current_index[0]+1).'.'.$this->current_index[1],
                'operation' => $operation,
                'message' => $e->getMessage()
            ]));
            return 0;
        }

    }

    public function parse_string(string $string, bool $is_global=false) {
        try{
            $string_arr = str_split($string);
            $new_string = '';
            $bracket_count = 0;
            $item = '';
            for($index=0;$index<count($string_arr); $index++) {
                $char = $string_arr[$index];
                if($char == '{') {
                    $bracket_count++;
                    continue;
                }
                if($char == '}') {
                    $bracket_count--;
                    $item = $this->parse_variable($item, true);
                    $new_string .= $item;
                    $item = '';
                    continue;
                }

                if($bracket_count > 0) {
                    $item .= $char;
                } else {
                    $new_string .= $char;
                }
            }

            array_push($this->operated_result, 'new string: '.$new_string.PHP_EOL);
            $result = $new_string;
            [$current_index, $current_key] = $this->current_index;
            if(!$is_global) {
                $this->relative_info_array[$current_index][$current_key] = $result;
            }
            return $result;
        } catch(Exception $e) {
            $this->error_flag = true;
            array_push($this->error_messages, Lang::get('validation.string_error', [
                'key' => $this->current_index[0].'.'.$this->current_index[1],
                'operation' => $string,
                'message' => $e->getMessage()
            ]));
        }
    }

    public function finish(array $stack, int $sp, int|float $left_operant, string $operator, int|float $right_operant){
            $result = 0;
            while($sp > 1){
                $result = $this->unit_operate($left_operant, $operator, $right_operant);

                array_pop($stack);
                array_pop($stack);
                array_pop($stack);
                $sp -= 2;
                if($sp == 0){
                    return $result;
                }
                $right_operant = $result;
                array_push($stack, $result);

                $operator = $stack[$sp - 1];
                $left_operant = $stack[$sp - 2];
            }
        }
    /**
     * ABABAB..BA
     */
    public function calculate(array $op) {
        if(!is_numeric($op[0]) || !is_numeric(end($op))){
            // 規格エラー
            throw new Exception('演算式ではない');
        }
        $operation_stack = [];
        $operation_stack_point = 0;
        $left_operant=null;
        $operator=null;
        $operator_level=null;

        $right_operant=null;
        $next_operator = null;
        $next_operator_level=null;
        $is_finished = false;
        $result = null;
        $operators = ['+', '-', '*', '/', '^', '>', '<', '=', '>=', '<=', '<>', '&', '|'];
        $operator_level_mapping = [
            '>' => 1,
            '<' => 1,
            '=' => 1,
            '>=' => 1,
            '<=' => 1,
            '<>' => 1,
            '|' => 2,
            '&' => 3,
            '+' => 4,
            '-' => 4,
            '*' => 5,
            '/' => 5,
            '^' => 6
        ];
        $index = 0;
        $item = null;
        while($index <= count($op)){
            $item = $op[$index++];
            if(is_null($left_operant) && $operation_stack_point == 0){
                // 最初は変数ごとに値を付ける
                $left_operant = $item;
                array_push($operation_stack, $item);
                $operation_stack_point++;
                if($index >= count($op)){
                    $result = $item;
                    return $result;
                }
                $item = $op[$index++];
            }

            if(is_null($operator) && $operation_stack_point == 1){
                $operator = $item;
                $operator_level = $operator_level_mapping[$operator];

                array_push($operation_stack, $item);
                $operation_stack_point++;
                $item = $op[$index++];
            }

            if(is_null($right_operant) && $operation_stack_point == 2) {
                $right_operant = $item;
                array_push($operation_stack, $item);
                $operation_stack_point++;
                if($index >= count($op)) {
                    $result = self::unit_operate($left_operant, $operator, $right_operant);
                    return $result;
                }
                $item = $op[$index++];
            }
            // 5
            if(is_null($next_operator) && $operation_stack_point == 3){
                $next_operator = $item;
                $next_operator_level = $operator_level_mapping[$next_operator];
                $item = $op[$index++];
            }
            /**
             * *|/ -> +|-|null
             * ^ -> *|/
             * ^ -> +|-
             */
            if($operator_level > $next_operator_level) {
                $operation_stack_point--;
                // 今のLORを算出する,　指針を左へ遷移する

                $result = $this->unit_operate($left_operant, $operator, $right_operant);
                array_pop($operation_stack);
                array_pop($operation_stack);
                array_pop($operation_stack);
                $operation_stack_point -= 2;
                $right_operant = $result;
                array_push($operation_stack, $right_operant);

                if($operation_stack_point > 1){
                    $operator = $operation_stack[$operation_stack_point - 1];
                    $operator_level = $operator_level_mapping[$operator];
                    $left_operant = $operation_stack[$operation_stack_point - 2];
                    /**
                     * ^ -> *|/ -> +|-
                     */
                    if($operator_level > $next_operator_level){
                        $result = $this->unit_operate($left_operant, $operator, $right_operant);
                        array_pop($operation_stack);
                        array_pop($operation_stack);
                        array_pop($operation_stack);
                        $operation_stack_point -= 2;
                        $right_operant = $result;
                        array_push($operation_stack, $right_operant);
                        if($operation_stack_point > 1){
                            $operator = $operation_stack[$operation_stack_point - 1];
                            $operator_level = $operator_level_mapping[$operator];
                            $left_operant = $operation_stack[$operation_stack_point - 2];

                            if($operator_level == $next_operator_level){
                                $result = $this->unit_operate($left_operant, $operator, $right_operant);
                                array_pop($operation_stack);
                                array_pop($operation_stack);
                                array_pop($operation_stack);
                                $operation_stack_point -= 2;
                                $left_operant = $result;
                                array_push($operation_stack, $left_operant);
                            } else {
                                $left_operant = $right_operant;
                            }
                        } else {
                            $left_operant = $right_operant;
                        }
                    } else if ($operator_level == $next_operator_level) {

                        $result = $this->unit_operate($left_operant, $operator, $right_operant);
                        array_pop($operation_stack);
                        array_pop($operation_stack);
                        array_pop($operation_stack);
                        $operation_stack_point -= 2;
                        $left_operant = $result;
                        array_push($operation_stack, $left_operant);

                    } else {
                        $left_operant = $right_operant;
                    }
                } else {
                    $left_operant = $right_operant;
                }
                $operation_stack_point++;
            } else if ($operator_level == $next_operator_level) {
                $operation_stack_point--;
                // 右へ
                $result = $this->unit_operate($left_operant, $operator, $right_operant);
                array_pop($operation_stack);
                array_pop($operation_stack);
                array_pop($operation_stack);
                $operation_stack_point -= 2;
                $left_operant = $result;
                array_push($operation_stack, $left_operant);
                $operation_stack_point++;
            } else {
                $left_operant = $right_operant;
                
            }

            $operator = $next_operator;
            $operator_level = $next_operator_level;
            array_push($operation_stack, $operator);
            $operation_stack_point++;

            $right_operant = $item;
            array_push($operation_stack, $right_operant);

            if($index >= count($op)){
                $result = $this->finish($operation_stack, $operation_stack_point, $left_operant, $operator, $right_operant);
                return $result;
            }
            $operation_stack_point++;
            $item = $op[$index++];
            $next_operator = $item;
            $next_operator_level = $operator_level_mapping[$next_operator];



        }
    }
    public function unit_operate(int|float $left_operant, string $operator, int|float $right_operant){
        $result = 0;
        switch($operator){
            case '+':
                $result = $left_operant + $right_operant;
                break;
            case '-':
                $result = $left_operant - $right_operant;
                break;
            case '*':
                $result = $left_operant * $right_operant;
                break;
            case '/':
                if($right_operant == 0){
                    // throw new Exception('規格エラー');
                    $result = 0;
                    break;
                }
                $result = $left_operant / $right_operant;
                break;
            case '^':
                $result = pow($left_operant, $right_operant);
                break;
            case '<':
                $result = $left_operant < $right_operant ? 1 : 0;
                break;
            case '>':
                $result = $left_operant > $right_operant ? 1 : 0;
                break;
            case '=':
                $result = $left_operant == $right_operant ? 1 : 0;
                break;
            case '<=':
                $result = $left_operant <= $right_operant ? 1 : 0;
                break;
            case '>=':
                $result = $left_operant >= $right_operant ? 1 : 0;
                break;
            case '<>':
                $result = $left_operant != $right_operant ? 1 : 0;
                break;
            case '&':
                $result = $left_operant && $right_operant ? 1 : 0;
                break;
            case '|':
                $result =  $left_operant || $right_operant ? 1 : 0;
                break;
            default;
                throw new Exception('規格エラー: left: '.$left_operant.', operator: '.$operator.', right: '.$right_operant);
        }
        return $result;
    }

    /**
     * 変数解析、php連想配列にマッピングするもので、まずはphp連想配列に変える
     * {$sql_aaaa} -> ['__d']['definited']['sql_aaa']
     * {$.bbb}->['__l']['bbb']
     * {$aa.bb.cc}->['__r']['aa']['bb']['cc']
     * {$18.value}->['__r'][18]['value']
     * {%a.b.c.18.cc}->['__ab']['a']['b']['c']['18']['cc']
     */
    public function parse_variable(string $variable, bool $is_string=false){
        $prefix = substr($variable, 0, 1);
        $index_list = [];
        $result = null;
        try{
            // {$a.b.c.12.value}
            if($prefix == '%'){
                if($this->array_key_stack->get_size() == 0){
                    $result = 0;
                    return $result;
                } else {
                    $local_array_key_stack = clone $this->array_key_stack;
                    // $local_array_key_stack->print_all();
                    $keys = preg_split('/\./', substr($variable, 1));
                    $target_array = $local_array_key_stack->get_array_handle($keys[0], $this->configuration);
                    $local_definited = $local_array_key_stack->get_definited();

                    $count_keys = count($keys);
                    if($count_keys<3) {
                        throw new \Exception('キー存在しない');
                    }
                    $v_index = null;
                    $v_key = null;
                    $local_relative_array = [];
                    array_push($this->relative_info_array_definited_stack, [$this->definited, $this->relative_info_array]);
                    // new relative_info_array and new definited
                    for($i=0; $i<$count_keys; $i++) {
                        if(array_key_exists($keys[$i], $target_array)){
                            if(is_numeric($keys[$i])){
                                $target_array = $target_array[$keys[$i] - 1];
                            } else {
                                $target_array = $target_array[$keys[$i]];
                            }
                            if($i == $count_keys-3) {
                                $local_relative_array = $target_array;
                            }
                            if($i == $count_keys-2) {
                                $v_index = $keys[$i] - 1;
                            } else if ($i == $count_keys - 1) {
                                $v_key = $keys[$i];
                            }
                        } else {
                            throw new \Exception('キーが存在しない');
                        }
                    }
                    $local_definited['year'] = $this->definited['year'];
                    $local_definited['month'] = $this->definited['month'];
                    $local_definited['year_month'] = $this->definited['year_month'];
                    $local_definited['last_month_year_month'] = $this->definited['last_month_year_month'];
                    $this->definited = $local_definited;
                    $this->relative_info_array = $local_relative_array;

                    array_push($this->current_index_stack, $this->current_index);
                    $this->current_index = [$v_index, $v_key];
                    $value = $target_array;
                    // echo '===========value: '.$value.PHP_EOL;
                    $result = $this->parse_operation($value);
                    // echo '==========result: '.$result.PHP_EOL;

                    [$this->definited, $this->relative_info_array] = array_pop($this->relative_info_array_definited_stack);

                    $this->current_index = array_pop($this->current_index_stack);

                    if(is_null($result)){
                        $result = 0;
                    }
                    array_push($this->operated_result, 'parse_variable: '.$variable.', result: '.$result.PHP_EOL);
                    return $result;

                }
            }
            else if($prefix == '$' && !preg_match('/\./', $variable)){
                // definited
                $key = substr($variable, 1);
                $value = $this->definited[substr($variable, 1)];
                if($is_string){
                    $result = $value;
                    return $result;
                }
                if(str_starts_with($key, 'sql_')){
                    $result = $this->parse_sql_prefix($value, true);
                } else if(str_starts_with($key, 's_')) {
                    $result = $this->parse_string($value, true);
                } else {
                    $result = $this->parse_operation($value, true);
                }
            } else if ($prefix == '$' && str_starts_with(substr($variable, 1), '.')) {
                // current_index
                $current_index = $this->current_index[0];

                $current_key = substr($variable, 2);
                $current_value = $this->relative_info_array[$current_index][$current_key];
                
                array_push($this->current_index_stack, $this->current_index);
                $this->current_index = [$current_index, $current_key];

                if($is_string){
                    $result = $current_value;
                    return $result;
                }

                if(str_starts_with($current_key, 'sql_')){
                    $result = $this->parse_sql_prefix($current_value);
                } else if(str_starts_with($current_key, 's_')) {
                    $result = $this->parse_string($current_value);
                } else {
                    $result = $this->parse_operation($current_value);
                }

                $this->current_index = array_pop($this->current_index_stack);
                [$current_index, $current_key] = $this->current_index;
                $this->relative_info_array[$current_index][$current_key] = $result;

            } else if ($prefix == '$' && preg_match('/\./', $variable)){
                // relative_variable
                $content = substr($variable, 1);
                $splited_content = preg_split('/\./', $content);
                $index = $splited_content[0] - 1;
                $key = $splited_content[1];

                array_push($this->current_index_stack, $this->current_index);
                $this->current_index = [$index, $key];
                
                $value = $this->relative_info_array[$index][$key];

                if($is_string){
                    $result = $value;
                    return $result;
                }
                if(str_starts_with($key, 'sql_')) {
                    $result = $this->parse_sql_prefix($value);
                } else if(str_starts_with($key, 's_')) {
                    $result = $this->parse_string($value);
                } else {
                    $result = $this->parse_operation($value);
                }
                $this->current_index = array_pop($this->current_index_stack);
                [$current_index, $current_key] = $this->current_index;
                $this->relative_info_array[$current_index][$current_key] = $result;

            } 
            if(is_null($result)){
                $result = 0;
            }
            array_push($this->operated_result, 'parse_variable: '.$variable.', result: '.$result.PHP_EOL);
            // echo 'parse_variable: '.$variable.', result: '.$result.PHP_EOL;
            return $result;

        } catch (Exception $e) {
            throw new Exception (
                array_push($this->error_messages, Lang::get('validation.operation_error', [
                    'key' => $this->current_index[0].'.'.$this->current_index[1],
                    'operation' => $variable,
                    'message' => $e->getMessage()
                ]))
            );
        }
    }

    /**
     * 000001{1.aa,bb}
     */

    public function parse_sql(string $sql_expression){
        $tblNames = ['tbl_meter_reading', 'tbl_contract_power_company_achievements'];
        if(str_starts_with($sql_expression, '_')){
            
            $id = substr($sql_expression, '1');
            $tblIndex = 0;
            $field = 'usage';
            $condition = 'meter_id';

            $current_key = $this->current_index[1];
            if(str_ends_with($current_key, '_last_month')){
                $year = substr($this->year_month, 0, 4);
                $month = substr($this->year_month, 4, 6);
                if($month == 1){
                    $year -= 1;
                    $month = 12;
                }else {
                    $month -= 1;
                }
                $year_month = $year.sprintf('%02d', $month);
            } else {
                $year_month = $this->year_month;
            }
            $sql_phrase = "select `{$field}` as result from {$tblNames[$tblIndex]} where {$condition}=\"{$id}\" and `year_month`=\"{$year_month}\"";


            $result = DB::select($sql_phrase);
            if(!$result){
                $result = 0;
            } else {
                $result = $result[0]->result;
            }
            array_push($this->operated_result, 'parse_sql: '. $sql_expression.', result: '.$result.PHP_EOL);
            return $result;
        }
        $operation_arr = str_split($sql_expression);
        array_push($this->operated_result, 'parse_sql: '.$sql_expression.PHP_EOL);
        // $id, $tblIndex, $field, ;
        $is_inner = false;
        $is_after_period = false;
        $is_after_comma = false;
        $id = null;
        $tblIndex = null;
        $field = null;
        $condition = null;
        for($index=0;$index<count($operation_arr); $index++){
            $char = $operation_arr[$index];

            if($char == '{'){
                $is_inner = true;
                continue;
            }
            if($char == '}'){
                break;
            }
            if($char == '.'){
                $is_after_period=true;
                continue;
            }

            if($char == ','){
                $is_after_comma = true;
                continue;
            }

            if(is_numeric($char) && !$is_inner){
                $id .= $char;
            } else if ($is_inner && !$is_after_period && !$is_after_comma){
                $tblIndex .= $char;
            } else if ($is_inner && $is_after_period && !$is_after_comma) {
                $field .= $char;
            } else if ($is_inner && $is_after_period && $is_after_comma) {
                $condition .= $char;
            }
        }

        if(!$condition){
            if($tblIndex == 1) {
                $condition = 'contract_power_company_id';
            } else {
                $condition = 'meter_id';
            }
        }
        if($id && $condition && $field){
            $current_key = $this->current_index[1];
            if(str_ends_with($current_key, '_last_month')){
                $year = substr($this->year_month, 0, 4);
                $month = substr($this->year_month, 4, 6);
                if($month == 1){
                    $year -= 1;
                    $month -=1;
                }else {
                    $month -= 1;
                }
                $year_month = $year.sprintf('%02d', $month);
            } else {
                $year_month = $this->year_month;
            }
            $sql_phrase = "select `{$field}` as result from {$tblNames[$tblIndex]} where {$condition}=\"{$id}\" and `year_month`=\"{$year_month}\"";
            array_push($this->operated_result, $sql_phrase.PHP_EOL);
            $result = DB::select($sql_phrase);
            if(!$result){
                $result = 0;
            } else {
                $result = $result[0]->result;
            }
        } else {
            $result = 0;
            array_push($this->error_messages, 'sql文で値が見つからない：'. $sql_expression.', id:'.$id.',tblIndex:'.$tblIndex.',condition:'.$condition.',field: '.$field);
        }
        // sql文請求
        return $result;
    }
    public function parse_sql_prefix($sql_phrase, $is_global=false){
        try{
            if($sql_phrase == null) {
                return 0;
            }
            if(is_numeric($sql_phrase)) {
                return $sql_phrase;
            }
            array_push($this->operated_result, 'parse_sql_prefix: '.$sql_phrase.PHP_EOL);
            // echo 'parse_sql_prefix: '.$sql_phrase.PHP_EOL;
            $bracket_count = 0;
            $item = '';
            $new_sql_phrase = '';
            $sql_phrase_arr = str_split($sql_phrase);
            for($index=0; $index<count($sql_phrase_arr); $index++) {
                $char = $sql_phrase_arr[$index];
                if($char == '{') {
                    $bracket_count++;
                    continue;
                }
                if($char == '}'){
                    $bracket_count--;
                    $item = $this->parse_variable($item);
                    $new_sql_phrase .= $item;
                    $item = '';
                    continue;
                }

                if($bracket_count > 0){
                    $item.=$char;
                } else {
                    $new_sql_phrase .= $char;
                }
            }
            $result = DB::select($new_sql_phrase);
            [$current_index,$current_key] = $this->current_index;
            if(count($result) > 0){
                if(property_exists($result[0], 'result')){
                    $result = $result[0]->result;
                } 
            } else {
                $result = 0;
            }
            if(!$is_global) {
                $this->relative_info_array[$current_index][$current_key] = $result;
            }
            return $result;

        } catch (Exception $e) {
            $this->error_flag = true;
            array_push($this->error_messages, Lang::get('validation.sql_error', [
                'key' => $this->current_index[0].'.'.$this->current_index[1],
                'operation' => $sql_phrase,
                'message' => $e->getMessage()
            ]));

        }
    }

    /**
     * 関数解析 SUM(), round(a, b), if(a,b,c)
     */
    public function parse_function(string $function){
        $function_chars = str_split($function);
        $bracket_count = 0;
        $is_inner = false;
        $prefix = '';
        $parameters = [];
        $parameter = '';
        $parameter_point = 0;
        $index = 0;
        for(;$index < count($function_chars); $index++) {
            $char = $function_chars[$index];
            if($char == '('){
                $is_inner = true;
                $index++;
                break;
            }
            if(!$is_inner){
                $prefix .= $char;
            }
        }
        for(; $index<count($function_chars)-1; $index++){
            $char = $function_chars[$index];
            if($char == ' '){
                continue;
            }
            if($char == '('){
                $bracket_count++;
            }
            
            if($char == ')'){
                $bracket_count--;
            }
            if($bracket_count == 0) {
                if($char == ','){
                    array_push($parameters, $parameter);
                    $parameter = '';
                    continue;
                } 
            }
            $parameter .= $char;
        }
        array_push($parameters, $parameter);
        
        if(strtoupper($prefix) == 'ROUND'){
            $result = $this->round($parameters[0], $parameters[1]);
        } else if (strtoupper($prefix) == 'IF') {
            $result = $this->operation_if($parameters[0], $parameters[1], $parameters[2]);
        } else if (strtoupper($prefix) == 'BETWEEN') {
            $result = $this->between($parameters[0], $parameters[1]);
        }else {
            $result = 0;
        }
        return $result;
    }
    public function round(string $num, string $precision) {
        if(!is_numeric($num)){
            $num = $this->parse_operation($num);
        }
        if(!is_numeric($precision)){
            $precision = $this->parse_operation($num);
        }
        return round($num, $precision);
    }

    public function operation_if(string $comparison, string $operation_true, string $operation_false){

        if(!is_numeric($comparison)){
            $comparison = $this->parse_operation($comparison);
            if($comparison > 0) {
                $comparison = true;
            } else {
                $comparison = false;
            }
        }
        if($comparison){
            if(!is_numeric($operation_true)){
                $operation_true = $this->parse_operation($operation_true);
            }
            $result = $operation_true;
        } else {
            if(!is_numeric($operation_false)) {
                $operation_false = $this->parse_operation($operation_false);
            }
            $result = $operation_false;
        }
        return $result;
    }

    public function between(string $min, string $max) {
        $result = 0;
        if(str_starts_with($min, '_')){
            $min = substr($min, 1);
        }

        if(str_starts_with($max, '_')) {
            $max = substr($max, 1);
        }
        for($i=$min; $i <= $max; $i++) {
            $result += $this->parse_sql('_'.$i);
        }
        return $result;
    }
}