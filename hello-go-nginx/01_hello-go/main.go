/**
 * Created by Wangwei on 2019/11/14 3:13 下午.
 */

package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/hello", hello)
	err := http.ListenAndServe("0.0.0.0:8080", nil)
	if err != nil {
		fmt.Println("http listen failed")
	}
}

func hello(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "<h1 style=\"color:red;\">Hello World Golang!</h1>")
}
