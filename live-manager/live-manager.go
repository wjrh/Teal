//This program handles the "what is playing right now" requests by returning the last played tracks for every program and organization.

package main

import (
	"bytes"
	"fmt"
	"net/http"
	"strings"
)

// map of strings for organizations
var organizations = make(map[string]string)

// map of strings for programs
var programs = make(map[string]string)

// all requests are handled by one function for now
func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}

func handler(w http.ResponseWriter, r *http.Request) {
	//strip the first forward slash and strip url into components
	urlPath := strings.Split(r.URL.Path[1:], "/")

	//return error if the url is not complete
	if len(urlPath) < 2 {
		fmt.Fprintf(w, "{'error':'url not properly formatted'}")
		return
	}

	entityName := urlPath[1]

	// post a new log - this method should be closed to outside users
	if r.Method == "POST" {
		// read from the reader to the buffer
		buffer := new(bytes.Buffer)
		buffer.ReadFrom(r.Body)
		body := buffer.String()
		if urlPath[0] == "organizations" {
			organizations[entityName] = body
		} else if urlPath[0] == "programs" {
			programs[entityName] = body
		} else {
			fmt.Fprintf(w, "{'error':'posting a new log, url not properly formatted'}")
		}
	} else {
		//determine if the first part of the url is orgs or progs
		if urlPath[0] == "organizations" {
			fmt.Fprintf(w, organizations[entityName])
		} else if urlPath[0] == "programs" {
			fmt.Fprintf(w, programs[entityName])
		} else {
			fmt.Fprintf(w, "{'error':'url not properly formatted'}")
		}
	}
}
