class Project {
  String _idProject;
  String _nameProject;

  Project(this._idProject, this._nameProject);

  String get nameProject => _nameProject;

  set nameProject(String value) {
    _nameProject = value;
  }

  String get idProject => _idProject;

  set idProject(String value) {
    _idProject = value;
  }
}