# BackgrounDRb Worker to reprocess assets.
class ProcessorReprocessWorker < BackgrounDRb::Rails
  # Reprocess and attactment - and sets it's backgroundrb_job_key to nil when it's done.
  # Expects args to be a hash - with values for the :class and :id of the Model Object to reprocess.
#  def do_work(args)
#    asset_class = eval("#{args[:class]}")
#    asset_id = args[:id]
#    asset_to_process = asset_class.find(asset_id)
#    asset_to_process.reprocess_asset_without_backgroundrb
#    key = asset_to_process.backgroundrb_job_key
#    asset_class.update_all(['backgroundrb_job_key = ?', nil], ['id = ?', asset_id])
#    MiddleMan.delete_worker(key)
#  end
end