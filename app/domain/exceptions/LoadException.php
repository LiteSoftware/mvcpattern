<?php

class LoadException extends BaseException {
    
    private $exceptions = [];   

    public function getExceptionsCount() : int {
        return count($this->exceptions);
    }
 
    public function addException(Exception $exception) {
        $this->exceptions []= $exception;
    }

    public function getExceptions() : array {
        return $this->exceptions;
    }
}