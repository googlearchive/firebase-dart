library firebase3.task_utils;

/// An event that is triggered on a task.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage#.TaskEvent>.
enum TaskEvent { STATE_CHANGED }

/// Represents the current state of a running upload.
///
/// See: <https://firebase.google.com/docs/reference/js/firebase.storage#.TaskState>.
enum TaskState { RUNNING, PAUSED, SUCCESS, CANCELED, ERROR }
