module EnvHelpers
  def stub_dhl_env_variables!
    before do
      allow(ENV).to receive(:[]).and_return(nil)
      allow(ENV).to receive(:[]).with("DHL_USERNAME").and_return("username")
      allow(ENV).to receive(:[]).with("DHL_PASSWORD").and_return("password")
      allow(ENV).to receive(:[]).with("DHL_ACCOUNT").and_return(123456789)
    end
  end
end
