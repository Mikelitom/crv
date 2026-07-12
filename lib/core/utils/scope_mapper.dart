String mapScope(String scope) {
  switch (scope) {
    case "ALL":
      return "General";
    case "PRESS":
      return "Prensas";
    case "VEHICLE":
      return "Vehiculos";
    case "CONVEYOR":
      return "Bandas";
    default:
      return "Desconocido";
  }
}
