@test
def test [] { }
@test
def test [] { }

@example "adding some dummy paths to an empty PATH" {
  with-env {PATH: []} {
    path add "returned" --ret
  }
} --result [returned]
@example "adding paths based on the operating system" {
  path add {linux: "foo"}
}
export def --env "path add" [
  --ret (-r), # return $env.PATH, useful in pipelines to avoid scoping.
  --append (-a), # append to $env.PATH instead of prepending to.
  p,
] { }

@search-terms multiply times
@example "random" { 2 | double }
@test
def double []: [number -> number] { $in * 2 }
