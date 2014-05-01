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


#### Get all forms

```
  forms = OdkAggregate::Form.all
  form = forms.first
  form.form_id
  form.download_url
  form.manifest_url

  OdkAggregate::Form.all.each do |form|
    puts form.get_top_element
  end
```

#### Find a single form

```
  form = OdkAggregate::Form.find(form_id)
  top_element = form.get_top_element
```

#### Find all submissions for a form

```
  submissions = OdkAggregate::Submission.where(formId: form_id).submissions
```

#### Find a single submission

```
  OdkAggregate::Submission.where(formId: form_id, key: submissions.first, topElement: top_element)

  OdkAggregate::Form.all.each do |form|
    top_element = form.get_top_element
    submissions = OdkAggregate::Submission.where(formId: form.form_id).submissions
    submission = OdkAggregate::Submission.where(formId: form.form_id, key: submissions.first, topElement: top_element)
    puts submission
  end

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
