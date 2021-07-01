#!/usr/bin/python3

import json
import requests

ASCII_ESC = "\033[0m"
ASCII_RED = "\033[31m"
ASCII_BLUE = "\033[34m"
ASCII_GREEN = "\033[32m"


class Tester:
    """Automated tester for Questionnaire
    To add a new test, add a call to do_test().
    To add a new test group, create a function for Tester and put in it
    do_test() calls, then call that function.
    """

    def __init__(self, app_root):
        self.app_root = app_root
        self.errors = list()
        self.test_count = 0

    def do_test(
        self,
        method: str,
        path: str,
        params: dict,
        body: dict,
        expected_response_code: int,
        expected_response: str,
        description: str,
    ):
        """Run a test with provided expected reponse and add to errors if test fails"""
        if method == "GET":
            r = requests.get(f"{self.app_root}/{path}", params=params)
        elif method == "POST":
            r = requests.post(f"{self.app_root}/{path}", data=json.dumps(body))
        elif method == "PUT":
            r = requests.put(f"{self.app_root}/{path}", data=json.dumps(body))
        elif method == "DELETE":
            r = requests.delete(f"{self.app_root}/{path}", params=params)
        else:
            print(f"Invalid method: {method}")
            return
        if r.status_code != expected_response_code or (
            expected_response and r.text != expected_response
        ):
            self.errors.append(
                (
                    method,
                    path,
                    (expected_response_code, r.status_code),
                    (expected_response, r.text),
                    description,
                )
            )
        self.test_count += 1

    def test_resources(self):
        print(f"{ASCII_BLUE}[*]{ASCII_ESC} ##### Testing Resources #####\n")

        resource_path = "api"

        ##### General #####

        resources = [
            "academicYear",
            "class",
            "faculty",
            "facultyInAcademicYear",
            "lecturer",
            "module",
            "moduleInProgramInAcademicYear",
            "program",
            "programInFacultyInAcademicYear",
            "questionnaire",
            "semester",
            "teaching",
        ]
        for resource in resources:
            path = f"{resource_path}/{resource}"
            # Invalid action -> 400
            self.do_test("GET", path, {"action": "invalid"}, None, 400, "Action 'invalid' is not supported", "invalid resource action")
            # dump -> 200
            self.do_test("GET", path, {"action": "dump"}, None, 200, None, f"dump {resource}")


        ##### Resources with ID & name #####
        resources = [
                "faculty",
                "module",
                "program"
        ]
        for resource in resources:
            path = f"{resource_path}/{resource}"
            self.do_test("PUT", path, None, {resource[0] + "name": "test"}, 400, None, "missing id")
            self.do_test("PUT", path, None, {resource[0] + "id": "10"}, 400, None, "missing name")
            self.do_test("PUT", path, None, {resource[0] + "id": "a"*11, resource[0] + "name": "test"}, 400, None, "ID too long")
            self.do_test("PUT", path, None, {resource[0] + "id": "a*", resource[0] + "name": "test"}, 400, None, "ID contains forbidden character")
            self.do_test("PUT", path, None, {resource[0] + "id": "10", resource[0] + "name": "a"*101}, 400, None, "name too long")
            self.do_test("PUT", path, None, {resource[0] + "id": "AAA_ZZZ-HI", resource[0] + "name": "test"}, 200, None, "valid data")

            self.do_test("DELETE", path, None, None, 400, f"One or more parameters is missing: {resource[0]}id", "missing id")
            self.do_test("DELETE", path, {resource[0] + "id": "10"}, None, 200, None, "valid id")


        ##### academicYear #####
        path = f"{resource_path}/academicYear"

        self.do_test("PUT", path, None, None, 400, "Malformed JSON request body", "empty body for academicYear")
        self.do_test("PUT", path, None, {"yid": "3000"}, 200, None, "Valid academicYear data")

        self.do_test("DELETE", path, None, None, 400, "One or more parameters is missing: yid", "No yid parameter")
        self.do_test("DELETE", path, {"yid": "3000"}, None, 200, None, "Valid yid")


        ##### class #####
        path = f"{resource_path}/class"

        # invalid cid, size, sid, mid -> 400
        self.do_test("PUT", path, None, None, 400, "Malformed JSON request body", "empty body for class")
        # cid
        self.do_test("PUT", path, None, {"size": 10, "sid": "1", "mid": "1"}, 400, "Malformed JSON request body: One or more parameters is missing: cid, sid, mid", "missing cid")
        self.do_test("PUT", path, None, {"cid": "a*", "size": 10, "sid": "1", "mid": "1"}, 400, "Malformed JSON request body: One or more parameters is invalid: cid, size, sid, mid", "cid contains forbidden ID character")
        self.do_test("PUT", path, None, {"cid": "A"*11, "size": 10, "sid": "1", "mid": "1"}, 400, "Malformed JSON request body: One or more parameters is invalid: cid, size, sid, mid", "cid too long")
        # sid
        self.do_test("PUT", path, None, {"cid": "1", "size": 10, "mid": "1"}, 400, "Malformed JSON request body: One or more parameters is missing: cid, sid, mid", "missing sid")
        self.do_test("PUT", path, None, {"cid": "1", "size": 10, "sid": "1#", "mid": "1"}, 400, "Malformed JSON request body: One or more parameters is invalid: cid, size, sid, mid", "sid contains forbidden ID character")
        self.do_test("PUT", path, None, {"cid": "1", "size": 10, "sid": "A"*11, "mid": "1"}, 400, "Malformed JSON request body: One or more parameters is invalid: cid, size, sid, mid", "sid too long")
        # mid
        self.do_test("PUT", path, None, {"cid": "1", "size": 10, "sid": "1"}, 400, "Malformed JSON request body: One or more parameters is missing: cid, sid, mid", "missing mid")
        self.do_test("PUT", path, None, {"cid": "1", "size": 10, "sid": "1", "mid": "1%"}, 400, "Malformed JSON request body: One or more parameters is invalid: cid, size, sid, mid", "mid contains forbidden ID character")
        self.do_test("PUT", path, None, {"cid": "1", "size": 10, "sid": "1", "mid": "A"*11}, 400, "Malformed JSON request body: One or more parameters is invalid: cid, size, sid, mid", "mid too long")
        # size
        self.do_test("PUT", path, None, {"cid": "1", "sid": "1", "mid": "1"}, 400, "Malformed JSON request body: One or more parameters is missing: cid, sid, mid", "missing size")
        self.do_test("PUT", path, None, {"cid": "1", "size": "a", "sid": "1", "mid": "1"}, 400, "Malformed JSON request body: size must be an integer", "size not int")
        # valid data -> 200
        self.do_test("PUT", path, None, {"cid": "AAA_ZZZ-HI", "size": 10, "sid": "A"*10, "mid": "A"*10}, 200, None, "Valid data")

        self.do_test("DELETE", path, None, None, 400, "One or more parameters is missing: cid", "missing cid")
        self.do_test("DELETE", path, {"cid": "1"}, None, 200, None, "valid cid")


        ##### facultyInAcademicYear #####
        path = f"{resource_path}/facultyInAcademicYear"

        self.do_test("GET", path, {"action": "getFaculties", "yid": "3000"}, None, 200, None, "getFaculties")

        self.do_test("PUT", path, None, None, 400, "Malformed JSON request body", "empty body for facultyInAcademicYear")
        self.do_test("PUT", path, None, {"fid": "10"}, 400, "Malformed JSON request body: One or more parameters is missing: fid, yid", "missing yid")
        self.do_test("PUT", path, None, {"yid": "3000"}, 400, "Malformed JSON request body: One or more parameters is missing: fid, yid", "missing fid")
        self.do_test("PUT", path, None, {"yid": "3000", "fid": "1aaaaaaaaaa"}, 400, "Malformed JSON request body: One or more parameters is invalid: fid, yid", "fid too long")
        self.do_test("PUT", path, None, {"yid": "3000", "fid": "1*"}, 400, "Malformed JSON request body: One or more parameters is invalid: fid, yid", "fid contains forbidden ID character")
        self.do_test("PUT", path, None, {"yid": "3000", "fid": "AAA_ZZZ-HI"}, 200, None, "valid data")

        self.do_test("DELETE", path, {"yid": "3000"}, None, 400, "One or more parameters is missing: fid, yid", "missing fid")
        self.do_test("DELETE", path, {"fid": "10"}, None, 400, "One or more parameters is missing: fid, yid", "missing yid")
        self.do_test("DELETE", path, {"fid": "AAA_ZZZ-HI", "yid": "3000"}, None, 200, None, "valid data")


        ##### lecturer #####
        path = f"{resource_path}/lecturer"
        self.do_test("PUT", path, None, {"username": "test"}, 400, "Malformed JSON request body: One or more parameters is missing: lid, username", "missing id")
        self.do_test("PUT", path, None, {"lid": "10"}, 400, None, "missing username")
        self.do_test("PUT", path, None, {"lid": "a"*11, "username": "test"}, 400, None, "ID too long")
        self.do_test("PUT", path, None, {"lid": "a*", "username": "test"}, 400, None, "ID contains forbidden character")
        self.do_test("PUT", path, None, {"lid": "10", "username": "a"*101}, 400, None, "name too long")
        self.do_test("PUT", path, None, {"lid": "AAA_ZZZ-HI", "username": "test"}, 200, None, "valid data")

        self.do_test("DELETE", path, None, None, 400, "One or more parameters is missing: lid", "missing id")
        self.do_test("DELETE", path, {"lid": "10"}, None, 200, None, "valid id")


        ##### moduleInProgramInAcademicYear #####
        path = f"{resource_path}/moduleInProgramInAcademicYear"

        self.do_test("GET", path, {"action": "getModules", "yid": "3000", "pid": "1"}, None, 200, None, "getModules")
        self.do_test("GET", path, {"action": "getClasses", "sid": "1", "pid": "1", "mid": "1"}, None, 200, None, "getClasses")

        self.do_test("PUT", path, None, None, 400, "Malformed JSON request body", "empty body for moduleInProgramInAcademicYear")
        self.do_test("PUT", path, None, {"pid": "10", "yid": "3000"}, 400, "Malformed JSON request body: One or more parameters is missing: mid, pid", "missing mid")
        self.do_test("PUT", path, None, {"mid": "10", "yid": "3000"}, 400, "Malformed JSON request body: One or more parameters is missing: mid, pid", "missing pid")
        self.do_test("PUT", path, None, {"mid": "10", "pid": "10"}, 400, "Malformed JSON request body: One or more parameters is missing: mid, pid", "missing yid")
        self.do_test("PUT", path, None, {"mid": "1"*11, "pid": "10", "yid": "3000"}, 400, "Malformed JSON request body: One or more parameters is invalid: mid, pid, yid", "mid too long")
        self.do_test("PUT", path, None, {"mid": "10", "pid": "1*", "yid": "3000"}, 400, "Malformed JSON request body: One or more parameters is invalid: mid, pid, yid", "pid contains forbidden ID character")
        self.do_test("PUT", path, None, {"mid": "AAA_ZZZ-HI", "pid": "A"*10, "yid": "3000"}, 200, None, "valid data")

        self.do_test("DELETE", path, {"mid": "AAA_ZZZ-HI", "yid": "3000"}, None, 400, "One or more parameters is missing: mid, pid, yid", "missing pid")
        self.do_test("DELETE", path, {"pid": "AAA_ZZZ-HI", "yid": "3000"}, None, 400, "One or more parameters is missing: mid, pid, yid", "missing mid")
        self.do_test("DELETE", path, {"mid": "10", "pid": "AAA_ZZZ-HI"}, None, 400, "One or more parameters is missing: mid, pid, yid", "missing yid")
        self.do_test("DELETE", path, {"mid": "AAA_ZZZ-HI", "pid": "AAA_ZZZ-HI", "yid": "3000"}, None, 200, None, "valid data")


        ##### programInFacultyInAcademicYear #####
        path = f"{resource_path}/programInFacultyInAcademicYear"

        self.do_test("GET", path, {"action": "getPrograms", "yid": "3000", "fid": "1"}, None, 200, None, "getPrograms")

        self.do_test("PUT", path, None, None, 400, "Malformed JSON request body", "empty body for programInFacultyInAcademicYear")
        self.do_test("PUT", path, None, {"fid": "10", "yid": "3000"}, 400, "Malformed JSON request body: One or more parameters is missing: pid, fid", "missing pid")
        self.do_test("PUT", path, None, {"pid": "10", "yid": "3000"}, 400, "Malformed JSON request body: One or more parameters is missing: pid, fid", "missing fid")
        self.do_test("PUT", path, None, {"pid": "10", "fid": "10"}, 400, "Malformed JSON request body: One or more parameters is missing: pid, fid", "missing yid")
        self.do_test("PUT", path, None, {"pid": "1"*11, "fid": "10", "yid": "3000"}, 400, "Malformed JSON request body: One or more parameters is invalid: pid, fid, yid", "mid too long")
        self.do_test("PUT", path, None, {"pid": "10", "fid": "1*", "yid": "3000"}, 400, "Malformed JSON request body: One or more parameters is invalid: pid, fid, yid", "pid contains forbidden ID character")
        self.do_test("PUT", path, None, {"pid": "AAA_ZZZ-HI", "fid": "A"*10, "yid": "3000"}, 200, None, "valid data")

        self.do_test("DELETE", path, {"yid": "3000"}, None, 400, "One or more parameters is missing: pid, yid", "missing pid")
        self.do_test("DELETE", path, {"pid": "10", "fid": "10"}, None, 400, "One or more parameters is missing: pid, yid", "missing yid")
        self.do_test("DELETE", path, {"pid": "AAA_ZZZ-HI", "yid": "3000"}, None, 200, None, "valid data")


        ##### questionnaire #####
        path = f"{resource_path}/questionnaire"
        # getCounts
        self.do_test("GET", path, {"action": "getCounts", "yid": "3000", "fid": "10", "pid": "10", "mid": "10", "q": "1"}, None, 200, None, "getCounts full valid parameters")
        self.do_test("GET", path, {"action": "getCounts", "q": "1"}, None, 200, None, "getCounts no ID valid parameters")
        self.do_test("GET", path, {"action": "getCounts", "q": "comment"}, None, 400, "Question comment is unvailable", "getCounts q=comment (invalid)")
        self.do_test("GET", path, {"action": "getCounts", "q": "invalid"}, None, 400, "Question invalid is unvailable", "getCounts invalid question")
        # getMaxResponseCount
        self.do_test("GET", path, {"action": "getMaxResponseCount", "yid": "3000", "sid": "WS01", "fid": "10", "pid": "10", "mid": "10"}, None, 200, None, "getMaxResponseCount full valid parameters")
        self.do_test("GET", path, {"action": "getMaxResponseCount"}, None, 200, None, "getMaxResponseCount no ID parameter")
        # getComments
        self.do_test("GET", path, {"action": "getComments", "cid": "1"}, None, 400, "One or more parameters is missing: cid, lid", "missing lid")
        self.do_test("GET", path, {"action": "getComments", "lid": "1"}, None, 400, "One or more parameters is missing: cid, lid", "missing cid")
        self.do_test("GET", path, {"action": "getComments", "cid": "1"*11, "lid": "1"}, None, 400, "One or more parameters is invalid: cid, lid", "invalid cid")
        self.do_test("GET", path, {"action": "getComments", "cid": "1", "lid": "1*"}, None, 400, "One or more parameters is invalid: cid, lid", "invalid lid")
        self.do_test("GET", path, {"action": "getComments", "cid": "1", "lid": "1"}, None, 200, None, "valid data")

        # PUT
        self.do_test("PUT", path, None, None, 400, "Malformed JSON request body", "empty body for questionnaire")
        self.do_test("PUT", path, None, {"lid": "10", "cid": "10", "gender": "M", "qa": [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], "comment": ""}, 200,  None, "valid questionnaire data")
        self.do_test("PUT", path, None, {"cid": "10", "gender": "M", "qa": [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], "comment": ""}, 400,  "Malformed JSON request body: One or more parameters is missing: lid, cid, gender, comment, qa", "missing lid")
        self.do_test("PUT", path, None, {"lid": "10", "gender": "M", "qa": [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], "comment": ""}, 400,  "Malformed JSON request body: One or more parameters is missing: lid, cid, gender, comment, qa", "missing cid")
        self.do_test("PUT", path, None, {"lid": "10", "cid": "10", "qa": [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], "comment": ""}, 400,  "Malformed JSON request body: One or more parameters is missing: lid, cid, gender, comment, qa", "missing gender")
        self.do_test("PUT", path, None, {"lid": "10", "cid": "10", "gender": "M", "comment": ""}, 400,  "Malformed JSON request body: One or more parameters is missing: lid, cid, gender, comment, qa", "missing qa")
        self.do_test("PUT", path, None, {"lid": "10", "cid": "10", "gender": "M", "qa": [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]}, 400,  "Malformed JSON request body: One or more parameters is missing: lid, cid, gender, comment, qa", "missing comment")
        self.do_test("PUT", path, None, {"lid": "10", "cid": "10", "gender": "X", "qa": [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], "comment": ""}, 400,  "Malformed JSON request body: One or more parameters is invalid: lid, cid, gender, qa, comment", "invalid gender")
        self.do_test("PUT", path, None, {"lid": "10", "cid": "10", "gender": "M", "qa": [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], "comment": "A"*501}, 400,  "Malformed JSON request body: One or more parameters is invalid: lid, cid, gender, qa, comment", "comment too long")
        self.do_test("PUT", path, None, {"lid": "10", "cid": "10", "gender": "M", "qa": [1], "comment": ""}, 400,  "Malformed JSON request body: There must be exactly 18 answers in the 'qa' array", "not enough answers")
        self.do_test("PUT", path, None, {"lid": "10", "cid": "10", "gender": "M", "qa": [1,1,1,1,1,1,1,1,1,1,1], "comment": ""}, 400,  "Malformed JSON request body: There must be exactly 18 answers in the 'qa' array", "too many answers")
        self.do_test("PUT", path, None, {"lid": "10", "cid": "10", "gender": "M", "qa": [6,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], "comment": ""}, 400,  "Malformed JSON request body: One or more parameters is invalid: lid, cid, gender, qa, comment", "invalid answer (>5)")
        self.do_test("PUT", path, None, {"lid": "10", "cid": "10", "gender": "M", "qa": ["a",1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1], "comment": ""}, 400,  "Malformed JSON request body: Answers must be integers", "invalid answer (not int)")
        self.do_test("PUT", path, None, {"lid": "10", "cid": "10", "gender": "M", "qa": [1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1], "comment": ""}, 400,  "Malformed JSON request body: One or more parameters is invalid: lid, cid, gender, qa, comment", "0 (N/A) where it's not allowed")
        # DELETE
        self.do_test("DELETE", path, {"lid": "AAA_ZZZ-HI", "cid": "A"*10, "qid": 1}, None, 200, None, "valid data")
        self.do_test("DELETE", path, {"cid": "10", "qid": 1}, None, 400, "One or more parameters is missing: lid, cid, qid", "missing cid")
        self.do_test("DELETE", path, {"lid": "10", "qid": 1}, None, 400, "One or more parameters is missing: lid, cid, qid", "missing lid")
        self.do_test("DELETE", path, {"lid": "10", "cid": "10"}, None, 400, "One or more parameters is missing: lid, cid, qid", "missing qid")
        self.do_test("DELETE", path, {"lid": "10", "cid": "10", "qid": "a"}, None, 400, None, "qid not int")


        ##### semester #####
        path = f"{resource_path}/semester"

        self.do_test("PUT", path, None, None, 400, "Malformed JSON request body", "empty body for semester")
        self.do_test("PUT", path, None, {"yid": "3000"}, 400, "Malformed JSON request body: One or more parameters is missing: sid", "missing sid")
        self.do_test("PUT", path, None, {"sid": "10"}, 400, "Malformed JSON request body: One or more parameters is missing: sid", "missing yid")
        self.do_test("PUT", path, None, {"sid": "A"*11, "yid": "3000"}, 400, "Malformed JSON request body: One or more parameters is invalid: sid, yid", "sid too long")
        self.do_test("PUT", path, None, {"sid": "AAA_ZZZ-HI", "yid": "3000"}, 200, None, "valid data")

        self.do_test("DELETE", path, None, None, 400, "One or more parameters is missing: sid", "missing sid")
        self.do_test("DELETE", path, {"sid": "AAA_ZZZ-HI"}, None, 200, None, "valid data")


        ##### teaching #####
        path = f"{resource_path}/teaching"

        self.do_test("GET", path, {"action": "getLecturers", "cid": "1"}, None, 200, None, "getLecturers")

        self.do_test("PUT", path, None, None, 400, "Malformed JSON request body", "empty body for teaching")
        self.do_test("PUT", path, None, {"cid": "10"}, 400, "Malformed JSON request body: One or more parameters is missing: lid, cid", "missing lid")
        self.do_test("PUT", path, None, {"lid": "10"}, 400, "Malformed JSON request body: One or more parameters is missing: lid, cid", "missing cid")
        self.do_test("PUT", path, None, {"lid": "1*", "cid": "10"}, 400, "Malformed JSON request body: One or more parameters is invalid: lid, cid", "lid contains forbidden ID character")
        self.do_test("PUT", path, None, {"lid": "10", "cid": "A"*11}, 400, "Malformed JSON request body: One or more parameters is invalid: lid, cid", "lid too long")
        self.do_test("PUT", path, None, {"lid": "AAA_ZZZ-HI", "cid": "A"*10}, 200, None, "valid data")

        self.do_test("DELETE", path, {"cid": "10"}, None, 400, "One or more parameters is missing: lid, cid", "missing lid")
        self.do_test("DELETE", path, {"lid": "10"}, None, 400, "One or more parameters is missing: lid, cid", "missing cid")
        self.do_test("DELETE", path, {"lid": "AAA_ZZZ-HI", "cid": "A"*10}, None, 200, None, "valid data")


        test.print_result("Resources all good")

    def print_result(self, msg_if_good: str):
        if self.errors:
            for error in self.errors:
                method, path, codes, texts, description = error
                print(f"{ASCII_RED}[!]{ASCII_ESC} {method} {path}")
                print(f"Description: {description}")
                print(f"Expected: {codes[0]}")
                print(f"    {texts[0]}")
                print(f"Actual result: {codes[1]}")
                print(f"    {texts[1]}")
                print()
        else:
            print(f"{ASCII_GREEN}[+]{ASCII_ESC} {msg_if_good}")
        print()
        self.errors = ()  # empty the errors for the next run


if __name__ == "__main__":
    app_root = "http://localhost:8080/Questionnaire"  # may be CHANGE THIS
    test = Tester(app_root)
    test.test_resources()
    print(f"{ASCII_BLUE}[*]{ASCII_ESC} Ran {test.test_count} tests")
