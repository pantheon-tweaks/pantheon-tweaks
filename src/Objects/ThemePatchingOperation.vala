namespace ElementaryTweaks {

  public class ThemePatchingQueue : Object
  {
    private uint ongoing_job_count = 0;
    private Queue<DelegateWrapper> pending_jobs =
        new Queue<DelegateWrapper> ();
   
    /* Change this to change the cap on the number of concurrent
     * operations. */
    private const uint max_jobs = 1;
   
    public async void patch_theme (bool enable_egtk_patch, int scrollbar_width, 
            int scrollbar_button_radius, string active_tab_underline_color, bool reset, bool verbose) 
        throws GLib.Error
      {
   
        /* If the number of ongoing operations is at the limit,
         * queue this operation and yield. */
        if (this.ongoing_job_count >
            ThemePatchingQueue.max_jobs)
          {
            /* Add to the pending queue. */
            var wrapper = new DelegateWrapper ();
            wrapper.cb = patch_theme.callback;
            this.pending_jobs.push_tail ((owned) wrapper);
            yield;
          }
   
        /* Do the actual store operation. */
        try
          {
            this.ongoing_job_count++;
            yield this.patch_theme_unlimited (enable_egtk_patch, scrollbar_width, scrollbar_button_radius, active_tab_underline_color, reset, verbose);
          }
        finally
          {
            this.ongoing_job_count--;
   
            /* If there is a store operation pending, resume it,
             * FIFO-style. */
            var wrapper = this.pending_jobs.pop_head ();
            if (wrapper != null)
              {
                wrapper.cb ();
              }
          }
   
        //return retval;
      }
   
    private async void patch_theme_unlimited (bool enable_egtk_patch, int scrollbar_width, 
            int scrollbar_button_radius, string active_tab_underline_color, bool reset, bool verbose) 
        throws GLib.Error
      {
        Pid child_pid;
        var cli = "%s/theme-patcher".printf (Build.PACKAGE_DATA_DIR);
        try {

            Process.spawn_async (null,
                {   "pkexec", cli,
                    enable_egtk_patch.to_string (),
                    scrollbar_width.to_string (),
                    scrollbar_button_radius.to_string (),
                    active_tab_underline_color,
                    reset.to_string (),
                    verbose.to_string ()                            
                },
                Environ.get (),
                SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
                null,
                out child_pid);
            if( verbose )
                message ( "Executing theme-patcher %s, %d, %d %s, %s %s", enable_egtk_patch.to_string (),
                    scrollbar_width, 
                    scrollbar_button_radius,
                    active_tab_underline_color,
                    reset.to_string (),
                    verbose.to_string ())  ;
        } catch (SpawnError e) {
            critical  ("error while executing '%s'. Message: '%s'.".printf (cli, e.message)) ;
        }
      }
  }
   
  /* See:
   * https://mail.gnome.org/archives/vala-list/2011-June/msg00005.html */
  [Compact]
  private class DelegateWrapper
  {
    public SourceFunc cb;
  }
}