api_key = CatarseSettings.find_by_name('iugu_api_key')
Iugu.api_key = api_key.try(:value)