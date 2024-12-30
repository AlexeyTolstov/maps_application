class ApiClient {
  static bool validateUser(String login, String password) {
    return login == "Alex777" && password == "31415";
  }

  static bool createNewUser(String login, String password) {
    return true; /// Если пользователь будет false
  }
}