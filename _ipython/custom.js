// leave at least 2 line with only a star on it below, or doc generation fails
/**
 *
 *
 */

// we want strict javascript that fails on ambiguous syntax
"using strict";

// activate extensions only after Notebook is initialized
require(["base/js/events"], function (events) {
    events.on("app_initialized.NotebookApp", function () {
        IPython.load_extensions('ExecuteTime')
        IPython.load_extensions('notify')
        IPython.load_extensions('toc')
    })
})

