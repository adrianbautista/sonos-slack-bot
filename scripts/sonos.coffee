sonos = require('sonos')
SonosDiscovery = require('sonos-discovery')
discovery = new SonosDiscovery()
speaker = new sonos.Sonos(process.env.SONOS_IP)

module.exports = (robot) ->

  robot.respond /whats playing/i, (msg) ->
    speaker.currentTrack (err, track) ->
      msg.send "#{track.artist}: #{track.title}"

  robot.respond /(play|unpause)(.*)/i, (msg) ->
    songuri = msg.match[2].trim()

    if songuri.length
      speaker.play songuri, (err, playing) ->
        if !err
          speaker.currentTrack (err, track) ->
            msg.send "#{track.artist}: #{track.title}"
    else
      speaker.play (err, playing) ->
        if !err
          speaker.currentTrack (err, track) ->
            msg.send "#{track.artist}: #{track.title}"

  robot.respond /play next/i, (msg) ->
    speaker.next (err, nexted) ->
      if (!err && nexted)
        speaker.currentTrack (err, track) ->
          msg.send "#{track.artist}: #{track.title}"
      else
        msg.send "beep boop I am a robot :toaster:"

  robot.respond /(stop|pause)/i, (msg) ->
    speaker.pause (err, paused) ->
      if (!err || !paused)
        msg.send "SHUT IT"
      else
        msg.send "upps"

  robot.respond /(turn up|turn down) (.*)/i, (msg) ->
    volume_level = msg.match[2]
    speaker.setVolume volume_level, (err, data) ->
      msg.send "Let's get loud"



  # robot.respond /queue (.*)/i, (msg) ->
  #   trackid = msg.match[1]


  robot.respond /spotify/i, (msg) ->
    # trackid = '5AdoS3gS47x40nBNlNmPQ8'
    # track_uri = 'x-sonos-spotify:spotify%3atrack%3a' + trackid

    spotifyUri = encodeURIComponent('spotify:album:19YQ10twgD5djBaBDUpH7o')
    trackUri = 'x-sonos-spotify:' + spotifyUri + '?sid=9&flags=32&sn=1'
    metadata = '<DIDL-Lite xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:upnp="urn:schemas-upnp-org:metadata-1-0/upnp/" ' +
               'xmlns:r="urn:schemas-rinconnetworks-com:metadata-1-0/" xmlns="urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/">' +
               "<item id=\"00030020#{trackUri}\"" + 'restricted="true"><upnp:class>object.item.audioItem.musicTrack</upnp:class>' +
               '<desc id="cdudn" nameSpace="urn:schemas-rinconnetworks-com:metadata-1-0/">SA_RINCON2311_X_#Svc2311-0-Token</desc></item></DIDL-Lite>'

    console.log('discovery', discovery)
    player = discovery.getPlayer('Office')
    console.log('player', player)
    player.coordinator.addURIToQueue(trackUri, metadata)

    # params =
    #   uri: trackUri,
    #   metadata: metadata

    # speaker.queueNext params, (err, res) ->
    #   if err
    #     msg.send console.log(err)
    #   else
    #     msg.send console.log(res)

  #   rand = Math.floor(Math.random()*(99999999-10000000+1)+10000000)

  #   speaker.queueNext({
  #     uri: track_uri,
  #     metadata: "&lt;DIDL-Lite xmlns:dc=&quot;http://purl.org/dc/elements/1.1/&quot; xmlns:upnp=&quot;urn:schemas-upnp-org:metadata-1-0/upnp/&quot; xmlns:r=&quot;urn:schemas-rinconnetworks-com:metadata-1-0/&quot; xmlns=&quot;urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/&quot;&gt;&lt;item id=&quot;#{rand}spotify%3a#{'track'}%3a#{trackid}&quot; restricted=&quot;true&quot;&gt;&lt;dc:title&gt;&lt;/dc:title&gt;&lt;upnp:class&gt;object.item.audioItem.musicTrack&lt;/upnp:class&gt;&lt;desc id=&quot;cdudn&quot; nameSpace=&quot;urn:schemas-rinconnetworks-com:metadata-1-0/&quot;&gt;SA_RINCON2311_X_#Svc2311-0-Token&lt;/desc&gt;&lt;/item&gt;&lt;/DIDL-Lite&gt;"
  #   }, (err,res) ->
  #     msg.send err
  #     msg.send console.log(res)
  #   )
    # speaker.addSpotify trackid, (err, res) ->
    #   msg.send err

  # robot.respond /(queue|que) next (.*)/i, (msg) ->
  #   songuri = msg.match[2].trim()

  #   speaker.queueNext songuri, (err, queued) ->
  #     if !err
  #       speaker.play (err, playing) ->
  #         if !err
  #           speaker.currentTrack (err, track) ->
  #             msg.send "#{track.artist}: #{track.title}"

  # robot.respond /music search (.*)/i, (msg) ->
  #   query = msg.match[1]

  #   speaker.searchMusicLibrary('tracks', query, {}, (err, data) ->
  #     msg.send console.log(data.items)
  #   )
