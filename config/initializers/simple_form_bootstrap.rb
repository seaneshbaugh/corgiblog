inputs = %w[
  CollectionSelectInput
  DateTimeInput
  FileInput
  GroupedCollectionSelectInput
  NumericInput
  PasswordInput
  RangeInput
  StringInput
  TextInput
]

inputs.each do |input_type|
  superclass = "SimpleForm::Inputs::#{input_type}".constantize

  new_class = Class.new(superclass) do
    def input_html_classes
      super.push('form-control')
    end
  end

  Object.const_set(input_type, new_class)
end

SimpleForm.setup do |config|
  config.wrappers :bootstrap3, :tag => 'div', :class => 'form-group', :error_class => 'has-error',
                  :defaults => { :input_html => { :class => 'default-class' } } do |b|

    b.use :html5
    b.use :min_max
    b.use :maxlength
    b.use :placeholder

    b.optional :pattern
    b.optional :readonly

    b.use :label_input
    b.use :hint,  :wrap_with => { :tag => 'span', :class => 'help-block' }
    b.use :error, :wrap_with => { :tag => 'span', :class => 'help-block has-error' }
  end

  config.wrappers :bootstrap3_horizontal, :tag => 'div', :class => 'form-group', :error_class => 'has-error',
                  :defaults => { :input_html => { :class => 'default-class' }, :wrapper_html => { :class => 'col-lg-10' } } do |b|

    b.use :html5
    b.use :min_max
    b.use :maxlength
    b.use :placeholder

    b.optional :pattern
    b.optional :readonly

    b.use :label
    b.wrapper :right_column, :tag => :div, :class => 'col-lg-8' do |component|
      component.use :input
    end
    b.use :hint,  :wrap_with => { :tag => 'span', :class => 'help-block' }
    b.use :error, :wrap_with => { :tag => 'div', :class => 'help-block has-error col-lg-2' }
  end

  config.wrappers :group, :tag => 'div', :class => 'form-group', :error_class => 'has-error',
                  :defaults => { :input_html => { :class => 'default-class' } }  do |b|

    b.use :html5
    b.use :min_max
    b.use :maxlength
    b.use :placeholder

    b.optional :pattern
    b.optional :readonly

    b.use :label
    b.use :input, :wrap_with => { :class => 'input-group' }
    b.use :hint,  :wrap_with => { :tag => 'span', :class => 'help-block' }
    b.use :error, :wrap_with => { :tag => 'span', :class => 'help-block has-error' }
  end

  config.label_class = 'col-lg-2 control-label'

  config.boolean_style = :nested

  config.default_wrapper = :bootstrap3_horizontal
end
