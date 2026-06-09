<?php

namespace App\Util;
class LinkNode {
    public mixed $value;
    public LinkNode|null $next_link;
    public LinkNode|null $prev_link;

    public function __construct(mixed $value, LinkNode|null $next_link, LinkNode|null $prev_link){
        $this->value = $value;
        $this->next_link = $next_link;
        $this->prev_link = $prev_link;

    }

}