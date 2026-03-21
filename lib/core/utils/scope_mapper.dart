String mapScope(String scope) {
  switch (scope) {
    case "General":
      return "ALL";
    case "Prensas":
      return "PRESS";
    case "Vehiculo":
      return "VEHICLE";
    case "Bandas":
      return "CONVEYOR";
    default:
      return "Desconocido";
  }
}
