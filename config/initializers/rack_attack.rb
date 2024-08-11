Rack::Attack.throttle('limit API', limit: 200, period: 60) do |req|
  if req.path.start_with?('/api')
    'true'
  end
end

Rack::Attack.throttle('limit subscriptions', limit: 200, period: 60) do |req|
  if req.path.start_with?('/subscribers')
    'true'
  end
end
