local ghURL = "https://api.github.com/repos/incinirate/Xenon/releases/latest"

if config.checkForUpdates ~= false then
  rapi.request(function(success, url, handle)
    if success then
      if url == ghURL then
        local releaseData = handle.readAll()
        handle.close()

        local release = json.decode(releaseData)
        if release.tag_name ~= versionTag then
          logger.warn("Version mismatch, latest release is "
            .. release.tag_name .. ", but running version is " .. versionTag)

          if release.tag_name:match("v(%d+)") ~= versionTag:match("v(%d+)") then
            logger.warn("Latest version has a major version seperation gap, it may not be safe to update. Review the changelog for more details.")
          end
        end
      end 
    else
      if url == ghURL then
        logger.warn("Unable to fetch release data")
      end
    end
  end, ghURL)
end
