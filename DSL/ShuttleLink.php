<?php
namespace App\Util;


// 往復
class ShuttleLink {
    private LinkNode $last_linkNode;
    private LinkNode $first_linkNode;
    private int $size;
    private array $definited;
    private array $definited_stack=[];

    public function __construct(mixed $value) {
        $this->last_linkNode = $this->first_linkNode = new LinkNode($value, null, null);
        $this->size = 1;
    }
    public function insert(mixed $value, int $index){
        if($index > $this->size) {
            throw new \Exception('overflow');
        }

        // 先端
        if($index == 0) {
            $tmp = new LinkNode($value, $this->first_linkNode, null);

            
            $this->first_linkNode->prev_link = $tmp;
            $this->first_linkNode = $tmp;
            $this->size++;
            return;
        }

        // 最後尾
        if($index == $this->size) {
            $this->push($value);
            return;
        }

        $tmp = new LinkNode($value, null, null);

        $point_tmp = $this->first_linkNode;
        $st = 0;
        do{
            $st++;
            // 0~size-1
            $point_tmp = $point_tmp->next_link;
        } while($st<$index);

        // 繋ぎ
        $prev_tmp = $point_tmp->prev_link;
        $next_tmp = $point_tmp;

        $tmp->next_link = $next_tmp;
        $next_tmp->prev_link = $tmp;

        $tmp->prev_link = $prev_tmp;
        $prev_tmp->next_link = $tmp;

        $this->size++;
        return;

    }
    public function push(mixed $value) {
        $tmp = new LinkNode($value, null, $this->last_linkNode);
        $this->last_linkNode->next_link = $tmp;
        $tmp->prev_link = $this->last_linkNode;
        $this->last_linkNode = $tmp;
        $this->size++;
    }
    public function pop() {
        if($this->size == 0) {
            throw new \Exception('cannot pop an empty shuttlelink');
        }

        $tmp = $this->last_linkNode;
        $this->last_linkNode = $this->last_linkNode->prev_link;
        $value = $tmp->value;
        unset($tmp);
        $this->size--;
        return $value;
    }

    public function is_exist(string $value): bool {
        $tmp = $this->last_linkNode;
        for(; !is_null($tmp->prev_link); $tmp = $tmp->prev_link){
            if($tmp->value == $value) {
                return true;
            }
        }
        return false;
    }

    public function get_array_handle(string $value, array $multi_level_array): array {
        $tmp = $this->last_linkNode;
        $tmp_array = $multi_level_array;
        $is_exist = false;
        for(; !is_null($tmp->prev_link); $tmp = $tmp->prev_link){
            if($tmp->value == $value) {
                $is_exist = true;
                break;
            }
        }

        if($is_exist){
            // %->a->b->c
            $tmp_2 = $this->first_linkNode->next_link;
            for(; $tmp_2 !== $tmp; $tmp_2 = $tmp_2->next_link) {

                if(array_key_exists('definited', $tmp_array)) {
                    array_push($this->definited_stack, $tmp_array['definited']);
                }
                $tmp_array = $tmp_array[$tmp_2->value];
            }
            if(array_key_exists('definited', $tmp_array)) {
                array_push($this->definited_stack, $tmp_array['definited']);
            }


            $this->definited = array_pop($this->definited_stack);

            return $tmp_array;

        } else {
            throw new \Exception('キー存在しない');

        }
        
    }
    public function index(int $in) {
        $tmp = $this->first_linkNode;
        $i = 0;
        for(; !is_null($tmp->next_link); $tmp = $tmp->next_link) {
            if($i === $in) {
                break;
            }
            $i++;
        }
        return $tmp->value;
    }

    public function print_all(bool $is_reverse=false) {
        $tmp = $this->first_linkNode;
        if($is_reverse) {
            $index = $this->size-1;
            for(; !is_null($tmp->prev_link); $tmp = $tmp->prev_link) {
                echo $index.'=>'.$tmp->value.PHP_EOL;
                $index--;
            }
            echo $index.'==>'.$tmp->value.PHP_EOL;
        } else {
            $index = 0;
            for(; !is_null($tmp->next_link); $tmp = $tmp->next_link) {
                echo $index.'==>'.$tmp->value.PHP_EOL;
                $index++;
            }
            echo $index.'==>'.$tmp->value.PHP_EOL;

        }
    }

    public function get_first_linkNode() {
        return $this->first_linkNode;
    }

    public function get_last_linkNode() {
        return $this->last_linkNode;
    }

    public function get_definited() {
        return $this->definited;
    }
    public function get_size() {
        return $this->size;
    }

}