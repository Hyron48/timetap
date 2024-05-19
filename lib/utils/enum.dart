enum AuthStatus {
  empty,
  authenticated,
  unauthenticated,
  unauthorized
}

enum ContentType {
  applicationJson,
  multipart
}

enum BlocStatus {
  empty,
  inProgress,
  success,
  failure,
  failureConsole,
  pagination,
  search
}