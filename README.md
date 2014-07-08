# OdkAggregate

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'odk_aggregate'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install odk_aggregate

## Usage

#### Initialize OdkAggregate

```
  @odk = OdkAggregate::Connection.new("http://your.url.com")
```


#### Get all forms

```
  forms = @odk.all_forms
  form = forms.first
  form.form_id
  form.download_url
  form.manifest_url

  @odk.all_forms.each do |form|
    puts form.get_top_element
  end
```

#### Find a single form

```
  form = @odk.find_form(form_id)
  top_element = form.get_top_element
```

#### Find all submissions for a form

```
  submissions = @odk.sumissions_where(formId: form_id).submissions
```

#### Find a single submission

```
  @odk.submissions_where(formId: form_id, key: submissions.first, topElement: top_element)

  @odk.all_forms.each do |form|
    top_element = form.get_top_element
    submissions = @odk.submissions_where(formId: form.form_id).submissions
    submission = @odk.submissions_where(formId: form.form_id, key: submissions.first, topElement: top_element)
    puts submission
  end

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
