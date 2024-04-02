dofile "lib/es.lua"

es.main {
    chapter = "test",
    onenter = function(s)
        es.walkdlg {
            dlg = "test",
            branch = "aux",
            pic = "ship/corridor",
            disp = "Test"
        }
    end
}