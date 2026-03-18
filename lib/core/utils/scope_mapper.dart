String mapScope(String scope) {
  switch (scope) {
    case "ALL":
      return "General";
    case "PRESS":
      return "Control de prensas";
    case "VEHICLE":
      return "Control de vehículos";
    case "CONVEYOR":
      return "Control de bandas";
    default:
      return "Desconocido";
  }
}
