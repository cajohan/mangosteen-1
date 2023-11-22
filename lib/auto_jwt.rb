class AutoJwt
  def initialize(app)
    @app = app
  end

  def call(env)
    # 状态码， 响应头， 响应体
    # [200, {}, ["Hello, World!", "Hi!"]]
    # jwt 跳过以下路径
    return @app.call(env) if ['/', '/api/v1/session', '/api/v1/validation_codes'].include? env['PATH_INFO']
    header = env["HTTP_AUTHORIZATION"]
    jwt = header.split(" ")[1] rescue ""
    begin
      payload = JWT.decode jwt, Rails.application.credentials.hmac_secret, true, { algorithm: "HS256" }
    rescue JWT::ExpiredSignature
      # JWT 过期，尝试使用 Refresh Token 刷新
      refresh_token = header.split(" ")[2] rescue ""
      begin
        refresh_result = refresh_jwt(refresh_token)
        if refresh_result[:success]
          # 刷新成功，更新当前用户信息
          new_jwt = refresh_result[:jwt]
          payload = JWT.decode new_jwt, Rails.application.credentials.hmac_secret, true, { algorithm: "HS256" }
          env["current_user_id"] = payload[0]["user_id"] rescue nil
          env["current_user_jwt"] = jwt rescue nil
        else
          # 刷新失败，返回特殊状态码
          return [401, {}, [JSON.generate({ reason: "token refresh failed" })]]
        end
      rescue
        # 刷新失败，返回未授权
        return [401, {}, [JSON.generate({ reason: "token refresh failed" })]]
      end
    rescue
      return [401, {}, [JSON.generate({ reason: "token invalid" })]]
    end
    env["current_user_id"] = payload[0]["user_id"] rescue nil
    env["current_user_jwt"] = jwt rescue nil
    @status, @headers, @response = @app.call(env)
    [@status, @headers, @response]
  end
end

def refresh_jwt(refresh_token)
  # 在这里实现 Refresh Token 的逻辑，生成新的 JWT
  # 你可以使用 ruby-jwt 等库进行 JWT 的生成
  # 返回一个哈希对象，包含成功标志和新生成的 JWT
  if refresh_token_valid?(refresh_token)
    payload_rt = JWT.decode refresh_token, Rails.application.credentials.hmac_secret, true, { algorithm: "HS256" }
    new_jwt = generate_jwt(payload_rt[0]["user_id"])
    { success: true, jwt: new_jwt }
  else
    { success: false }
  end
end

def refresh_token_valid?(refresh_token)
  return false if refresh_token.nil?
  begin
    decoded = JWT.decode(refresh_token, Rails.application.credentials.hmac_secret, true, algorithm: "HS256").first
    return decoded["exp"] > Time.now.to_i
  rescue JWT::DecodeError
    return false
  end
end

def generate_jwt(id)
  payload = { user_id: id, exp: (Time.now + 2.hours).to_i }
  JWT.encode payload, Rails.application.credentials.hmac_secret, "HS256"
end
