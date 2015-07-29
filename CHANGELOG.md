This file should attempt to stick to [http://keepachangelog.com/](http://keepachangelog.com/)

# Change Log
All notable changes to this project will be documented in this file.
This project will mostly attempt to stick to [Semantic Versioning](http://semver.org/), but since I'm new to this, no promises just yet.

## [Unreleased][unreleased]
### Changed
### Fixed
- generated index.html.erb was generating code with `singular_table_name` rather than substituting it with the correct actual singular table name (eg `post`, `category`, etc)
- generated _form.html.erb uses f.association rather than regular f.input

## [0.2.0] - 2015-07-27
### Changed
- AdminCrudHelper#new_link accepts hash as second parameter (rather than single string for URL)
- AdminCrudHelpe#td_delete takes 2nd param `options` with :url and :disabled keys
- AdminCrudHelpe#td_edit takes 2nd param `options` with :url key

### Added
- Devise views for `administrator` so app's don't have to maintain their own copy