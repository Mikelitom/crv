// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VehiclesTableTable extends VehiclesTable
    with TableInfo<$VehiclesTableTable, VehiclesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeIdMeta = const VerificationMeta('typeId');
  @override
  late final GeneratedColumn<String> typeId = GeneratedColumn<String>(
    'type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plateMeta = const VerificationMeta('plate');
  @override
  late final GeneratedColumn<String> plate = GeneratedColumn<String>(
    'plate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<int> unit = GeneratedColumn<int>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    typeId,
    brand,
    model,
    year,
    plate,
    unit,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<VehiclesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type_id')) {
      context.handle(
        _typeIdMeta,
        typeId.isAcceptableOrUnknown(data['type_id']!, _typeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_typeIdMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('plate')) {
      context.handle(
        _plateMeta,
        plate.isAcceptableOrUnknown(data['plate']!, _plateMeta),
      );
    } else if (isInserting) {
      context.missing(_plateMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VehiclesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VehiclesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      typeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type_id'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $VehiclesTableTable createAlias(String alias) {
    return $VehiclesTableTable(attachedDatabase, alias);
  }
}

class VehiclesTableData extends DataClass
    implements Insertable<VehiclesTableData> {
  final String id;
  final String typeId;
  final String brand;
  final String model;
  final int year;
  final String plate;
  final int unit;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const VehiclesTableData({
    required this.id,
    required this.typeId,
    required this.brand,
    required this.model,
    required this.year,
    required this.plate,
    required this.unit,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type_id'] = Variable<String>(typeId);
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    map['year'] = Variable<int>(year);
    map['plate'] = Variable<String>(plate);
    map['unit'] = Variable<int>(unit);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  VehiclesTableCompanion toCompanion(bool nullToAbsent) {
    return VehiclesTableCompanion(
      id: Value(id),
      typeId: Value(typeId),
      brand: Value(brand),
      model: Value(model),
      year: Value(year),
      plate: Value(plate),
      unit: Value(unit),
      isActive: Value(isActive),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory VehiclesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VehiclesTableData(
      id: serializer.fromJson<String>(json['id']),
      typeId: serializer.fromJson<String>(json['typeId']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      year: serializer.fromJson<int>(json['year']),
      plate: serializer.fromJson<String>(json['plate']),
      unit: serializer.fromJson<int>(json['unit']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'typeId': serializer.toJson<String>(typeId),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'year': serializer.toJson<int>(year),
      'plate': serializer.toJson<String>(plate),
      'unit': serializer.toJson<int>(unit),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  VehiclesTableData copyWith({
    String? id,
    String? typeId,
    String? brand,
    String? model,
    int? year,
    String? plate,
    int? unit,
    bool? isActive,
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => VehiclesTableData(
    id: id ?? this.id,
    typeId: typeId ?? this.typeId,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    year: year ?? this.year,
    plate: plate ?? this.plate,
    unit: unit ?? this.unit,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  VehiclesTableData copyWithCompanion(VehiclesTableCompanion data) {
    return VehiclesTableData(
      id: data.id.present ? data.id.value : this.id,
      typeId: data.typeId.present ? data.typeId.value : this.typeId,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      year: data.year.present ? data.year.value : this.year,
      plate: data.plate.present ? data.plate.value : this.plate,
      unit: data.unit.present ? data.unit.value : this.unit,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesTableData(')
          ..write('id: $id, ')
          ..write('typeId: $typeId, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('plate: $plate, ')
          ..write('unit: $unit, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    typeId,
    brand,
    model,
    year,
    plate,
    unit,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehiclesTableData &&
          other.id == this.id &&
          other.typeId == this.typeId &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.year == this.year &&
          other.plate == this.plate &&
          other.unit == this.unit &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VehiclesTableCompanion extends UpdateCompanion<VehiclesTableData> {
  final Value<String> id;
  final Value<String> typeId;
  final Value<String> brand;
  final Value<String> model;
  final Value<int> year;
  final Value<String> plate;
  final Value<int> unit;
  final Value<bool> isActive;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const VehiclesTableCompanion({
    this.id = const Value.absent(),
    this.typeId = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.plate = const Value.absent(),
    this.unit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesTableCompanion.insert({
    required String id,
    required String typeId,
    required String brand,
    required String model,
    required int year,
    required String plate,
    required int unit,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       typeId = Value(typeId),
       brand = Value(brand),
       model = Value(model),
       year = Value(year),
       plate = Value(plate),
       unit = Value(unit);
  static Insertable<VehiclesTableData> custom({
    Expression<String>? id,
    Expression<String>? typeId,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<int>? year,
    Expression<String>? plate,
    Expression<int>? unit,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (typeId != null) 'type_id': typeId,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (plate != null) 'plate': plate,
      if (unit != null) 'unit': unit,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? typeId,
    Value<String>? brand,
    Value<String>? model,
    Value<int>? year,
    Value<String>? plate,
    Value<int>? unit,
    Value<bool>? isActive,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return VehiclesTableCompanion(
      id: id ?? this.id,
      typeId: typeId ?? this.typeId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      plate: plate ?? this.plate,
      unit: unit ?? this.unit,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (typeId.present) {
      map['type_id'] = Variable<String>(typeId.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (plate.present) {
      map['plate'] = Variable<String>(plate.value);
    }
    if (unit.present) {
      map['unit'] = Variable<int>(unit.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesTableCompanion(')
          ..write('id: $id, ')
          ..write('typeId: $typeId, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('plate: $plate, ')
          ..write('unit: $unit, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportsVehicleTableTable extends ReportsVehicleTable
    with TableInfo<$ReportsVehicleTableTable, ReportsVehicleTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportsVehicleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responsibleIdMeta = const VerificationMeta(
    'responsibleId',
  );
  @override
  late final GeneratedColumn<String> responsibleId = GeneratedColumn<String>(
    'responsible_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inspectionDateMeta = const VerificationMeta(
    'inspectionDate',
  );
  @override
  late final GeneratedColumn<DateTime> inspectionDate =
      GeneratedColumn<DateTime>(
        'inspection_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _mileageMeta = const VerificationMeta(
    'mileage',
  );
  @override
  late final GeneratedColumn<int> mileage = GeneratedColumn<int>(
    'mileage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requiresServiceMeta = const VerificationMeta(
    'requiresService',
  );
  @override
  late final GeneratedColumn<bool> requiresService = GeneratedColumn<bool>(
    'requires_service',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_service" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _observationMeta = const VerificationMeta(
    'observation',
  );
  @override
  late final GeneratedColumn<String> observation = GeneratedColumn<String>(
    'observation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _generalNotesMeta = const VerificationMeta(
    'generalNotes',
  );
  @override
  late final GeneratedColumn<String> generalNotes = GeneratedColumn<String>(
    'general_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _folioMeta = const VerificationMeta('folio');
  @override
  late final GeneratedColumn<String> folio = GeneratedColumn<String>(
    'folio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    responsibleId,
    inspectionDate,
    mileage,
    requiresService,
    observation,
    generalNotes,
    folio,
    state,
    createdAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reports_vehicle_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportsVehicleTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('responsible_id')) {
      context.handle(
        _responsibleIdMeta,
        responsibleId.isAcceptableOrUnknown(
          data['responsible_id']!,
          _responsibleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_responsibleIdMeta);
    }
    if (data.containsKey('inspection_date')) {
      context.handle(
        _inspectionDateMeta,
        inspectionDate.isAcceptableOrUnknown(
          data['inspection_date']!,
          _inspectionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionDateMeta);
    }
    if (data.containsKey('mileage')) {
      context.handle(
        _mileageMeta,
        mileage.isAcceptableOrUnknown(data['mileage']!, _mileageMeta),
      );
    } else if (isInserting) {
      context.missing(_mileageMeta);
    }
    if (data.containsKey('requires_service')) {
      context.handle(
        _requiresServiceMeta,
        requiresService.isAcceptableOrUnknown(
          data['requires_service']!,
          _requiresServiceMeta,
        ),
      );
    }
    if (data.containsKey('observation')) {
      context.handle(
        _observationMeta,
        observation.isAcceptableOrUnknown(
          data['observation']!,
          _observationMeta,
        ),
      );
    }
    if (data.containsKey('general_notes')) {
      context.handle(
        _generalNotesMeta,
        generalNotes.isAcceptableOrUnknown(
          data['general_notes']!,
          _generalNotesMeta,
        ),
      );
    }
    if (data.containsKey('folio')) {
      context.handle(
        _folioMeta,
        folio.isAcceptableOrUnknown(data['folio']!, _folioMeta),
      );
    } else if (isInserting) {
      context.missing(_folioMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportsVehicleTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportsVehicleTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      responsibleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}responsible_id'],
      )!,
      inspectionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}inspection_date'],
      )!,
      mileage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mileage'],
      )!,
      requiresService: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_service'],
      )!,
      observation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observation'],
      ),
      generalNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}general_notes'],
      ),
      folio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folio'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $ReportsVehicleTableTable createAlias(String alias) {
    return $ReportsVehicleTableTable(attachedDatabase, alias);
  }
}

class ReportsVehicleTableData extends DataClass
    implements Insertable<ReportsVehicleTableData> {
  final String id;
  final String vehicleId;
  final String responsibleId;
  final DateTime inspectionDate;
  final int mileage;
  final bool requiresService;
  final String? observation;
  final String? generalNotes;
  final String folio;
  final String state;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isSynced;
  const ReportsVehicleTableData({
    required this.id,
    required this.vehicleId,
    required this.responsibleId,
    required this.inspectionDate,
    required this.mileage,
    required this.requiresService,
    this.observation,
    this.generalNotes,
    required this.folio,
    required this.state,
    required this.createdAt,
    this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['responsible_id'] = Variable<String>(responsibleId);
    map['inspection_date'] = Variable<DateTime>(inspectionDate);
    map['mileage'] = Variable<int>(mileage);
    map['requires_service'] = Variable<bool>(requiresService);
    if (!nullToAbsent || observation != null) {
      map['observation'] = Variable<String>(observation);
    }
    if (!nullToAbsent || generalNotes != null) {
      map['general_notes'] = Variable<String>(generalNotes);
    }
    map['folio'] = Variable<String>(folio);
    map['state'] = Variable<String>(state);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  ReportsVehicleTableCompanion toCompanion(bool nullToAbsent) {
    return ReportsVehicleTableCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      responsibleId: Value(responsibleId),
      inspectionDate: Value(inspectionDate),
      mileage: Value(mileage),
      requiresService: Value(requiresService),
      observation: observation == null && nullToAbsent
          ? const Value.absent()
          : Value(observation),
      generalNotes: generalNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(generalNotes),
      folio: Value(folio),
      state: Value(state),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory ReportsVehicleTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportsVehicleTableData(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      responsibleId: serializer.fromJson<String>(json['responsibleId']),
      inspectionDate: serializer.fromJson<DateTime>(json['inspectionDate']),
      mileage: serializer.fromJson<int>(json['mileage']),
      requiresService: serializer.fromJson<bool>(json['requiresService']),
      observation: serializer.fromJson<String?>(json['observation']),
      generalNotes: serializer.fromJson<String?>(json['generalNotes']),
      folio: serializer.fromJson<String>(json['folio']),
      state: serializer.fromJson<String>(json['state']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'responsibleId': serializer.toJson<String>(responsibleId),
      'inspectionDate': serializer.toJson<DateTime>(inspectionDate),
      'mileage': serializer.toJson<int>(mileage),
      'requiresService': serializer.toJson<bool>(requiresService),
      'observation': serializer.toJson<String?>(observation),
      'generalNotes': serializer.toJson<String?>(generalNotes),
      'folio': serializer.toJson<String>(folio),
      'state': serializer.toJson<String>(state),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  ReportsVehicleTableData copyWith({
    String? id,
    String? vehicleId,
    String? responsibleId,
    DateTime? inspectionDate,
    int? mileage,
    bool? requiresService,
    Value<String?> observation = const Value.absent(),
    Value<String?> generalNotes = const Value.absent(),
    String? folio,
    String? state,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    bool? isSynced,
  }) => ReportsVehicleTableData(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    responsibleId: responsibleId ?? this.responsibleId,
    inspectionDate: inspectionDate ?? this.inspectionDate,
    mileage: mileage ?? this.mileage,
    requiresService: requiresService ?? this.requiresService,
    observation: observation.present ? observation.value : this.observation,
    generalNotes: generalNotes.present ? generalNotes.value : this.generalNotes,
    folio: folio ?? this.folio,
    state: state ?? this.state,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  ReportsVehicleTableData copyWithCompanion(ReportsVehicleTableCompanion data) {
    return ReportsVehicleTableData(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      responsibleId: data.responsibleId.present
          ? data.responsibleId.value
          : this.responsibleId,
      inspectionDate: data.inspectionDate.present
          ? data.inspectionDate.value
          : this.inspectionDate,
      mileage: data.mileage.present ? data.mileage.value : this.mileage,
      requiresService: data.requiresService.present
          ? data.requiresService.value
          : this.requiresService,
      observation: data.observation.present
          ? data.observation.value
          : this.observation,
      generalNotes: data.generalNotes.present
          ? data.generalNotes.value
          : this.generalNotes,
      folio: data.folio.present ? data.folio.value : this.folio,
      state: data.state.present ? data.state.value : this.state,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportsVehicleTableData(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('responsibleId: $responsibleId, ')
          ..write('inspectionDate: $inspectionDate, ')
          ..write('mileage: $mileage, ')
          ..write('requiresService: $requiresService, ')
          ..write('observation: $observation, ')
          ..write('generalNotes: $generalNotes, ')
          ..write('folio: $folio, ')
          ..write('state: $state, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    responsibleId,
    inspectionDate,
    mileage,
    requiresService,
    observation,
    generalNotes,
    folio,
    state,
    createdAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportsVehicleTableData &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.responsibleId == this.responsibleId &&
          other.inspectionDate == this.inspectionDate &&
          other.mileage == this.mileage &&
          other.requiresService == this.requiresService &&
          other.observation == this.observation &&
          other.generalNotes == this.generalNotes &&
          other.folio == this.folio &&
          other.state == this.state &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class ReportsVehicleTableCompanion
    extends UpdateCompanion<ReportsVehicleTableData> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String> responsibleId;
  final Value<DateTime> inspectionDate;
  final Value<int> mileage;
  final Value<bool> requiresService;
  final Value<String?> observation;
  final Value<String?> generalNotes;
  final Value<String> folio;
  final Value<String> state;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const ReportsVehicleTableCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.responsibleId = const Value.absent(),
    this.inspectionDate = const Value.absent(),
    this.mileage = const Value.absent(),
    this.requiresService = const Value.absent(),
    this.observation = const Value.absent(),
    this.generalNotes = const Value.absent(),
    this.folio = const Value.absent(),
    this.state = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportsVehicleTableCompanion.insert({
    required String id,
    required String vehicleId,
    required String responsibleId,
    required DateTime inspectionDate,
    required int mileage,
    this.requiresService = const Value.absent(),
    this.observation = const Value.absent(),
    this.generalNotes = const Value.absent(),
    required String folio,
    required String state,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       responsibleId = Value(responsibleId),
       inspectionDate = Value(inspectionDate),
       mileage = Value(mileage),
       folio = Value(folio),
       state = Value(state),
       createdAt = Value(createdAt);
  static Insertable<ReportsVehicleTableData> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? responsibleId,
    Expression<DateTime>? inspectionDate,
    Expression<int>? mileage,
    Expression<bool>? requiresService,
    Expression<String>? observation,
    Expression<String>? generalNotes,
    Expression<String>? folio,
    Expression<String>? state,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (responsibleId != null) 'responsible_id': responsibleId,
      if (inspectionDate != null) 'inspection_date': inspectionDate,
      if (mileage != null) 'mileage': mileage,
      if (requiresService != null) 'requires_service': requiresService,
      if (observation != null) 'observation': observation,
      if (generalNotes != null) 'general_notes': generalNotes,
      if (folio != null) 'folio': folio,
      if (state != null) 'state': state,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportsVehicleTableCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String>? responsibleId,
    Value<DateTime>? inspectionDate,
    Value<int>? mileage,
    Value<bool>? requiresService,
    Value<String?>? observation,
    Value<String?>? generalNotes,
    Value<String>? folio,
    Value<String>? state,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return ReportsVehicleTableCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      responsibleId: responsibleId ?? this.responsibleId,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      mileage: mileage ?? this.mileage,
      requiresService: requiresService ?? this.requiresService,
      observation: observation ?? this.observation,
      generalNotes: generalNotes ?? this.generalNotes,
      folio: folio ?? this.folio,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (responsibleId.present) {
      map['responsible_id'] = Variable<String>(responsibleId.value);
    }
    if (inspectionDate.present) {
      map['inspection_date'] = Variable<DateTime>(inspectionDate.value);
    }
    if (mileage.present) {
      map['mileage'] = Variable<int>(mileage.value);
    }
    if (requiresService.present) {
      map['requires_service'] = Variable<bool>(requiresService.value);
    }
    if (observation.present) {
      map['observation'] = Variable<String>(observation.value);
    }
    if (generalNotes.present) {
      map['general_notes'] = Variable<String>(generalNotes.value);
    }
    if (folio.present) {
      map['folio'] = Variable<String>(folio.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportsVehicleTableCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('responsibleId: $responsibleId, ')
          ..write('inspectionDate: $inspectionDate, ')
          ..write('mileage: $mileage, ')
          ..write('requiresService: $requiresService, ')
          ..write('observation: $observation, ')
          ..write('generalNotes: $generalNotes, ')
          ..write('folio: $folio, ')
          ..write('state: $state, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VehicleReportVersionsTableTable extends VehicleReportVersionsTable
    with
        TableInfo<
          $VehicleReportVersionsTableTable,
          VehicleReportVersionsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehicleReportVersionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportIdMeta = const VerificationMeta(
    'reportId',
  );
  @override
  late final GeneratedColumn<String> reportId = GeneratedColumn<String>(
    'report_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionNumberMeta = const VerificationMeta(
    'versionNumber',
  );
  @override
  late final GeneratedColumn<int> versionNumber = GeneratedColumn<int>(
    'version_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCurrentMeta = const VerificationMeta(
    'isCurrent',
  );
  @override
  late final GeneratedColumn<bool> isCurrent = GeneratedColumn<bool>(
    'is_current',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_current" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reportId,
    versionNumber,
    isCurrent,
    createdBy,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicle_report_versions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<VehicleReportVersionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('report_id')) {
      context.handle(
        _reportIdMeta,
        reportId.isAcceptableOrUnknown(data['report_id']!, _reportIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reportIdMeta);
    }
    if (data.containsKey('version_number')) {
      context.handle(
        _versionNumberMeta,
        versionNumber.isAcceptableOrUnknown(
          data['version_number']!,
          _versionNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_versionNumberMeta);
    }
    if (data.containsKey('is_current')) {
      context.handle(
        _isCurrentMeta,
        isCurrent.isAcceptableOrUnknown(data['is_current']!, _isCurrentMeta),
      );
    } else if (isInserting) {
      context.missing(_isCurrentMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VehicleReportVersionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VehicleReportVersionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      reportId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_id'],
      )!,
      versionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version_number'],
      )!,
      isCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_current'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $VehicleReportVersionsTableTable createAlias(String alias) {
    return $VehicleReportVersionsTableTable(attachedDatabase, alias);
  }
}

class VehicleReportVersionsTableData extends DataClass
    implements Insertable<VehicleReportVersionsTableData> {
  final String id;
  final String reportId;
  final int versionNumber;
  final bool isCurrent;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const VehicleReportVersionsTableData({
    required this.id,
    required this.reportId,
    required this.versionNumber,
    required this.isCurrent,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['report_id'] = Variable<String>(reportId);
    map['version_number'] = Variable<int>(versionNumber);
    map['is_current'] = Variable<bool>(isCurrent);
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  VehicleReportVersionsTableCompanion toCompanion(bool nullToAbsent) {
    return VehicleReportVersionsTableCompanion(
      id: Value(id),
      reportId: Value(reportId),
      versionNumber: Value(versionNumber),
      isCurrent: Value(isCurrent),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory VehicleReportVersionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VehicleReportVersionsTableData(
      id: serializer.fromJson<String>(json['id']),
      reportId: serializer.fromJson<String>(json['reportId']),
      versionNumber: serializer.fromJson<int>(json['versionNumber']),
      isCurrent: serializer.fromJson<bool>(json['isCurrent']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reportId': serializer.toJson<String>(reportId),
      'versionNumber': serializer.toJson<int>(versionNumber),
      'isCurrent': serializer.toJson<bool>(isCurrent),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  VehicleReportVersionsTableData copyWith({
    String? id,
    String? reportId,
    int? versionNumber,
    bool? isCurrent,
    String? createdBy,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => VehicleReportVersionsTableData(
    id: id ?? this.id,
    reportId: reportId ?? this.reportId,
    versionNumber: versionNumber ?? this.versionNumber,
    isCurrent: isCurrent ?? this.isCurrent,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  VehicleReportVersionsTableData copyWithCompanion(
    VehicleReportVersionsTableCompanion data,
  ) {
    return VehicleReportVersionsTableData(
      id: data.id.present ? data.id.value : this.id,
      reportId: data.reportId.present ? data.reportId.value : this.reportId,
      versionNumber: data.versionNumber.present
          ? data.versionNumber.value
          : this.versionNumber,
      isCurrent: data.isCurrent.present ? data.isCurrent.value : this.isCurrent,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehicleReportVersionsTableData(')
          ..write('id: $id, ')
          ..write('reportId: $reportId, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reportId,
    versionNumber,
    isCurrent,
    createdBy,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehicleReportVersionsTableData &&
          other.id == this.id &&
          other.reportId == this.reportId &&
          other.versionNumber == this.versionNumber &&
          other.isCurrent == this.isCurrent &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VehicleReportVersionsTableCompanion
    extends UpdateCompanion<VehicleReportVersionsTableData> {
  final Value<String> id;
  final Value<String> reportId;
  final Value<int> versionNumber;
  final Value<bool> isCurrent;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const VehicleReportVersionsTableCompanion({
    this.id = const Value.absent(),
    this.reportId = const Value.absent(),
    this.versionNumber = const Value.absent(),
    this.isCurrent = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehicleReportVersionsTableCompanion.insert({
    required String id,
    required String reportId,
    required int versionNumber,
    required bool isCurrent,
    required String createdBy,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       reportId = Value(reportId),
       versionNumber = Value(versionNumber),
       isCurrent = Value(isCurrent),
       createdBy = Value(createdBy),
       createdAt = Value(createdAt);
  static Insertable<VehicleReportVersionsTableData> custom({
    Expression<String>? id,
    Expression<String>? reportId,
    Expression<int>? versionNumber,
    Expression<bool>? isCurrent,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reportId != null) 'report_id': reportId,
      if (versionNumber != null) 'version_number': versionNumber,
      if (isCurrent != null) 'is_current': isCurrent,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehicleReportVersionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? reportId,
    Value<int>? versionNumber,
    Value<bool>? isCurrent,
    Value<String>? createdBy,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return VehicleReportVersionsTableCompanion(
      id: id ?? this.id,
      reportId: reportId ?? this.reportId,
      versionNumber: versionNumber ?? this.versionNumber,
      isCurrent: isCurrent ?? this.isCurrent,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reportId.present) {
      map['report_id'] = Variable<String>(reportId.value);
    }
    if (versionNumber.present) {
      map['version_number'] = Variable<int>(versionNumber.value);
    }
    if (isCurrent.present) {
      map['is_current'] = Variable<bool>(isCurrent.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehicleReportVersionsTableCompanion(')
          ..write('id: $id, ')
          ..write('reportId: $reportId, ')
          ..write('versionNumber: $versionNumber, ')
          ..write('isCurrent: $isCurrent, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReportAnswersVehicleTableTable extends ReportAnswersVehicleTable
    with
        TableInfo<
          $ReportAnswersVehicleTableTable,
          ReportAnswersVehicleTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportAnswersVehicleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reportVersionIdMeta = const VerificationMeta(
    'reportVersionId',
  );
  @override
  late final GeneratedColumn<String> reportVersionId = GeneratedColumn<String>(
    'report_version_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _componentIdMeta = const VerificationMeta(
    'componentId',
  );
  @override
  late final GeneratedColumn<String> componentId = GeneratedColumn<String>(
    'component_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionIdMeta = const VerificationMeta(
    'optionId',
  );
  @override
  late final GeneratedColumn<String> optionId = GeneratedColumn<String>(
    'option_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _observationMeta = const VerificationMeta(
    'observation',
  );
  @override
  late final GeneratedColumn<String> observation = GeneratedColumn<String>(
    'observation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reportVersionId,
    componentId,
    optionId,
    observation,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'report_answers_vehicle_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportAnswersVehicleTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('report_version_id')) {
      context.handle(
        _reportVersionIdMeta,
        reportVersionId.isAcceptableOrUnknown(
          data['report_version_id']!,
          _reportVersionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reportVersionIdMeta);
    }
    if (data.containsKey('component_id')) {
      context.handle(
        _componentIdMeta,
        componentId.isAcceptableOrUnknown(
          data['component_id']!,
          _componentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_componentIdMeta);
    }
    if (data.containsKey('option_id')) {
      context.handle(
        _optionIdMeta,
        optionId.isAcceptableOrUnknown(data['option_id']!, _optionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_optionIdMeta);
    }
    if (data.containsKey('observation')) {
      context.handle(
        _observationMeta,
        observation.isAcceptableOrUnknown(
          data['observation']!,
          _observationMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportAnswersVehicleTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportAnswersVehicleTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      reportVersionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_version_id'],
      )!,
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}component_id'],
      )!,
      optionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_id'],
      )!,
      observation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observation'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReportAnswersVehicleTableTable createAlias(String alias) {
    return $ReportAnswersVehicleTableTable(attachedDatabase, alias);
  }
}

class ReportAnswersVehicleTableData extends DataClass
    implements Insertable<ReportAnswersVehicleTableData> {
  final String id;
  final String reportVersionId;
  final String componentId;
  final String optionId;
  final String? observation;
  final DateTime createdAt;
  const ReportAnswersVehicleTableData({
    required this.id,
    required this.reportVersionId,
    required this.componentId,
    required this.optionId,
    this.observation,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['report_version_id'] = Variable<String>(reportVersionId);
    map['component_id'] = Variable<String>(componentId);
    map['option_id'] = Variable<String>(optionId);
    if (!nullToAbsent || observation != null) {
      map['observation'] = Variable<String>(observation);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReportAnswersVehicleTableCompanion toCompanion(bool nullToAbsent) {
    return ReportAnswersVehicleTableCompanion(
      id: Value(id),
      reportVersionId: Value(reportVersionId),
      componentId: Value(componentId),
      optionId: Value(optionId),
      observation: observation == null && nullToAbsent
          ? const Value.absent()
          : Value(observation),
      createdAt: Value(createdAt),
    );
  }

  factory ReportAnswersVehicleTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportAnswersVehicleTableData(
      id: serializer.fromJson<String>(json['id']),
      reportVersionId: serializer.fromJson<String>(json['reportVersionId']),
      componentId: serializer.fromJson<String>(json['componentId']),
      optionId: serializer.fromJson<String>(json['optionId']),
      observation: serializer.fromJson<String?>(json['observation']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reportVersionId': serializer.toJson<String>(reportVersionId),
      'componentId': serializer.toJson<String>(componentId),
      'optionId': serializer.toJson<String>(optionId),
      'observation': serializer.toJson<String?>(observation),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReportAnswersVehicleTableData copyWith({
    String? id,
    String? reportVersionId,
    String? componentId,
    String? optionId,
    Value<String?> observation = const Value.absent(),
    DateTime? createdAt,
  }) => ReportAnswersVehicleTableData(
    id: id ?? this.id,
    reportVersionId: reportVersionId ?? this.reportVersionId,
    componentId: componentId ?? this.componentId,
    optionId: optionId ?? this.optionId,
    observation: observation.present ? observation.value : this.observation,
    createdAt: createdAt ?? this.createdAt,
  );
  ReportAnswersVehicleTableData copyWithCompanion(
    ReportAnswersVehicleTableCompanion data,
  ) {
    return ReportAnswersVehicleTableData(
      id: data.id.present ? data.id.value : this.id,
      reportVersionId: data.reportVersionId.present
          ? data.reportVersionId.value
          : this.reportVersionId,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      optionId: data.optionId.present ? data.optionId.value : this.optionId,
      observation: data.observation.present
          ? data.observation.value
          : this.observation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportAnswersVehicleTableData(')
          ..write('id: $id, ')
          ..write('reportVersionId: $reportVersionId, ')
          ..write('componentId: $componentId, ')
          ..write('optionId: $optionId, ')
          ..write('observation: $observation, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reportVersionId,
    componentId,
    optionId,
    observation,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportAnswersVehicleTableData &&
          other.id == this.id &&
          other.reportVersionId == this.reportVersionId &&
          other.componentId == this.componentId &&
          other.optionId == this.optionId &&
          other.observation == this.observation &&
          other.createdAt == this.createdAt);
}

class ReportAnswersVehicleTableCompanion
    extends UpdateCompanion<ReportAnswersVehicleTableData> {
  final Value<String> id;
  final Value<String> reportVersionId;
  final Value<String> componentId;
  final Value<String> optionId;
  final Value<String?> observation;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReportAnswersVehicleTableCompanion({
    this.id = const Value.absent(),
    this.reportVersionId = const Value.absent(),
    this.componentId = const Value.absent(),
    this.optionId = const Value.absent(),
    this.observation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportAnswersVehicleTableCompanion.insert({
    required String id,
    required String reportVersionId,
    required String componentId,
    required String optionId,
    this.observation = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       reportVersionId = Value(reportVersionId),
       componentId = Value(componentId),
       optionId = Value(optionId),
       createdAt = Value(createdAt);
  static Insertable<ReportAnswersVehicleTableData> custom({
    Expression<String>? id,
    Expression<String>? reportVersionId,
    Expression<String>? componentId,
    Expression<String>? optionId,
    Expression<String>? observation,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reportVersionId != null) 'report_version_id': reportVersionId,
      if (componentId != null) 'component_id': componentId,
      if (optionId != null) 'option_id': optionId,
      if (observation != null) 'observation': observation,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportAnswersVehicleTableCompanion copyWith({
    Value<String>? id,
    Value<String>? reportVersionId,
    Value<String>? componentId,
    Value<String>? optionId,
    Value<String?>? observation,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ReportAnswersVehicleTableCompanion(
      id: id ?? this.id,
      reportVersionId: reportVersionId ?? this.reportVersionId,
      componentId: componentId ?? this.componentId,
      optionId: optionId ?? this.optionId,
      observation: observation ?? this.observation,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reportVersionId.present) {
      map['report_version_id'] = Variable<String>(reportVersionId.value);
    }
    if (componentId.present) {
      map['component_id'] = Variable<String>(componentId.value);
    }
    if (optionId.present) {
      map['option_id'] = Variable<String>(optionId.value);
    }
    if (observation.present) {
      map['observation'] = Variable<String>(observation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportAnswersVehicleTableCompanion(')
          ..write('id: $id, ')
          ..write('reportVersionId: $reportVersionId, ')
          ..write('componentId: $componentId, ')
          ..write('optionId: $optionId, ')
          ..write('observation: $observation, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EvidenceVehicleTableTable extends EvidenceVehicleTable
    with TableInfo<$EvidenceVehicleTableTable, EvidenceVehicleTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EvidenceVehicleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerIdMeta = const VerificationMeta(
    'answerId',
  );
  @override
  late final GeneratedColumn<String> answerId = GeneratedColumn<String>(
    'answer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileTypeMeta = const VerificationMeta(
    'fileType',
  );
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
    'file_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
    'file_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    answerId,
    filePath,
    fileType,
    mimeType,
    fileSize,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evidence_vehicle_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EvidenceVehicleTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('answer_id')) {
      context.handle(
        _answerIdMeta,
        answerId.isAcceptableOrUnknown(data['answer_id']!, _answerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_answerIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(
        _fileTypeMeta,
        fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EvidenceVehicleTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EvidenceVehicleTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      answerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fileType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_type'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EvidenceVehicleTableTable createAlias(String alias) {
    return $EvidenceVehicleTableTable(attachedDatabase, alias);
  }
}

class EvidenceVehicleTableData extends DataClass
    implements Insertable<EvidenceVehicleTableData> {
  final String id;
  final String answerId;
  final String filePath;
  final String fileType;
  final String mimeType;
  final int? fileSize;
  final DateTime createdAt;
  const EvidenceVehicleTableData({
    required this.id,
    required this.answerId,
    required this.filePath,
    required this.fileType,
    required this.mimeType,
    this.fileSize,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['answer_id'] = Variable<String>(answerId);
    map['file_path'] = Variable<String>(filePath);
    map['file_type'] = Variable<String>(fileType);
    map['mime_type'] = Variable<String>(mimeType);
    if (!nullToAbsent || fileSize != null) {
      map['file_size'] = Variable<int>(fileSize);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EvidenceVehicleTableCompanion toCompanion(bool nullToAbsent) {
    return EvidenceVehicleTableCompanion(
      id: Value(id),
      answerId: Value(answerId),
      filePath: Value(filePath),
      fileType: Value(fileType),
      mimeType: Value(mimeType),
      fileSize: fileSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSize),
      createdAt: Value(createdAt),
    );
  }

  factory EvidenceVehicleTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EvidenceVehicleTableData(
      id: serializer.fromJson<String>(json['id']),
      answerId: serializer.fromJson<String>(json['answerId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileType: serializer.fromJson<String>(json['fileType']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      fileSize: serializer.fromJson<int?>(json['fileSize']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'answerId': serializer.toJson<String>(answerId),
      'filePath': serializer.toJson<String>(filePath),
      'fileType': serializer.toJson<String>(fileType),
      'mimeType': serializer.toJson<String>(mimeType),
      'fileSize': serializer.toJson<int?>(fileSize),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EvidenceVehicleTableData copyWith({
    String? id,
    String? answerId,
    String? filePath,
    String? fileType,
    String? mimeType,
    Value<int?> fileSize = const Value.absent(),
    DateTime? createdAt,
  }) => EvidenceVehicleTableData(
    id: id ?? this.id,
    answerId: answerId ?? this.answerId,
    filePath: filePath ?? this.filePath,
    fileType: fileType ?? this.fileType,
    mimeType: mimeType ?? this.mimeType,
    fileSize: fileSize.present ? fileSize.value : this.fileSize,
    createdAt: createdAt ?? this.createdAt,
  );
  EvidenceVehicleTableData copyWithCompanion(
    EvidenceVehicleTableCompanion data,
  ) {
    return EvidenceVehicleTableData(
      id: data.id.present ? data.id.value : this.id,
      answerId: data.answerId.present ? data.answerId.value : this.answerId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceVehicleTableData(')
          ..write('id: $id, ')
          ..write('answerId: $answerId, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    answerId,
    filePath,
    fileType,
    mimeType,
    fileSize,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EvidenceVehicleTableData &&
          other.id == this.id &&
          other.answerId == this.answerId &&
          other.filePath == this.filePath &&
          other.fileType == this.fileType &&
          other.mimeType == this.mimeType &&
          other.fileSize == this.fileSize &&
          other.createdAt == this.createdAt);
}

class EvidenceVehicleTableCompanion
    extends UpdateCompanion<EvidenceVehicleTableData> {
  final Value<String> id;
  final Value<String> answerId;
  final Value<String> filePath;
  final Value<String> fileType;
  final Value<String> mimeType;
  final Value<int?> fileSize;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EvidenceVehicleTableCompanion({
    this.id = const Value.absent(),
    this.answerId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileType = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EvidenceVehicleTableCompanion.insert({
    required String id,
    required String answerId,
    required String filePath,
    required String fileType,
    required String mimeType,
    this.fileSize = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       answerId = Value(answerId),
       filePath = Value(filePath),
       fileType = Value(fileType),
       mimeType = Value(mimeType),
       createdAt = Value(createdAt);
  static Insertable<EvidenceVehicleTableData> custom({
    Expression<String>? id,
    Expression<String>? answerId,
    Expression<String>? filePath,
    Expression<String>? fileType,
    Expression<String>? mimeType,
    Expression<int>? fileSize,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (answerId != null) 'answer_id': answerId,
      if (filePath != null) 'file_path': filePath,
      if (fileType != null) 'file_type': fileType,
      if (mimeType != null) 'mime_type': mimeType,
      if (fileSize != null) 'file_size': fileSize,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EvidenceVehicleTableCompanion copyWith({
    Value<String>? id,
    Value<String>? answerId,
    Value<String>? filePath,
    Value<String>? fileType,
    Value<String>? mimeType,
    Value<int?>? fileSize,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return EvidenceVehicleTableCompanion(
      id: id ?? this.id,
      answerId: answerId ?? this.answerId,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (answerId.present) {
      map['answer_id'] = Variable<String>(answerId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EvidenceVehicleTableCompanion(')
          ..write('id: $id, ')
          ..write('answerId: $answerId, ')
          ..write('filePath: $filePath, ')
          ..write('fileType: $fileType, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingVehicleReportsTableTable extends PendingVehicleReportsTable
    with
        TableInfo<
          $PendingVehicleReportsTableTable,
          PendingVehicleReportsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingVehicleReportsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folioMeta = const VerificationMeta('folio');
  @override
  late final GeneratedColumn<String> folio = GeneratedColumn<String>(
    'folio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    folio,
    payload,
    isSynced,
    createdAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_vehicle_reports_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingVehicleReportsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('folio')) {
      context.handle(
        _folioMeta,
        folio.isAcceptableOrUnknown(data['folio']!, _folioMeta),
      );
    } else if (isInserting) {
      context.missing(_folioMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingVehicleReportsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingVehicleReportsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      folio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folio'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $PendingVehicleReportsTableTable createAlias(String alias) {
    return $PendingVehicleReportsTableTable(attachedDatabase, alias);
  }
}

class PendingVehicleReportsTableData extends DataClass
    implements Insertable<PendingVehicleReportsTableData> {
  final String id;
  final String vehicleId;
  final String folio;
  final String payload;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime? syncedAt;
  const PendingVehicleReportsTableData({
    required this.id,
    required this.vehicleId,
    required this.folio,
    required this.payload,
    required this.isSynced,
    required this.createdAt,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['folio'] = Variable<String>(folio);
    map['payload'] = Variable<String>(payload);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  PendingVehicleReportsTableCompanion toCompanion(bool nullToAbsent) {
    return PendingVehicleReportsTableCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      folio: Value(folio),
      payload: Value(payload),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory PendingVehicleReportsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingVehicleReportsTableData(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      folio: serializer.fromJson<String>(json['folio']),
      payload: serializer.fromJson<String>(json['payload']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'folio': serializer.toJson<String>(folio),
      'payload': serializer.toJson<String>(payload),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  PendingVehicleReportsTableData copyWith({
    String? id,
    String? vehicleId,
    String? folio,
    String? payload,
    bool? isSynced,
    DateTime? createdAt,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => PendingVehicleReportsTableData(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    folio: folio ?? this.folio,
    payload: payload ?? this.payload,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  PendingVehicleReportsTableData copyWithCompanion(
    PendingVehicleReportsTableCompanion data,
  ) {
    return PendingVehicleReportsTableData(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      folio: data.folio.present ? data.folio.value : this.folio,
      payload: data.payload.present ? data.payload.value : this.payload,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingVehicleReportsTableData(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('folio: $folio, ')
          ..write('payload: $payload, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, vehicleId, folio, payload, isSynced, createdAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingVehicleReportsTableData &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.folio == this.folio &&
          other.payload == this.payload &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class PendingVehicleReportsTableCompanion
    extends UpdateCompanion<PendingVehicleReportsTableData> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String> folio;
  final Value<String> payload;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const PendingVehicleReportsTableCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.folio = const Value.absent(),
    this.payload = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingVehicleReportsTableCompanion.insert({
    required String id,
    required String vehicleId,
    required String folio,
    required String payload,
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       folio = Value(folio),
       payload = Value(payload);
  static Insertable<PendingVehicleReportsTableData> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? folio,
    Expression<String>? payload,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (folio != null) 'folio': folio,
      if (payload != null) 'payload': payload,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingVehicleReportsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String>? folio,
    Value<String>? payload,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<DateTime?>? syncedAt,
    Value<int>? rowid,
  }) {
    return PendingVehicleReportsTableCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      folio: folio ?? this.folio,
      payload: payload ?? this.payload,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (folio.present) {
      map['folio'] = Variable<String>(folio.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingVehicleReportsTableCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('folio: $folio, ')
          ..write('payload: $payload, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTableTable vehiclesTable = $VehiclesTableTable(this);
  late final $ReportsVehicleTableTable reportsVehicleTable =
      $ReportsVehicleTableTable(this);
  late final $VehicleReportVersionsTableTable vehicleReportVersionsTable =
      $VehicleReportVersionsTableTable(this);
  late final $ReportAnswersVehicleTableTable reportAnswersVehicleTable =
      $ReportAnswersVehicleTableTable(this);
  late final $EvidenceVehicleTableTable evidenceVehicleTable =
      $EvidenceVehicleTableTable(this);
  late final $PendingVehicleReportsTableTable pendingVehicleReportsTable =
      $PendingVehicleReportsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehiclesTable,
    reportsVehicleTable,
    vehicleReportVersionsTable,
    reportAnswersVehicleTable,
    evidenceVehicleTable,
    pendingVehicleReportsTable,
  ];
}

typedef $$VehiclesTableTableCreateCompanionBuilder =
    VehiclesTableCompanion Function({
      required String id,
      required String typeId,
      required String brand,
      required String model,
      required int year,
      required String plate,
      required int unit,
      Value<bool> isActive,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$VehiclesTableTableUpdateCompanionBuilder =
    VehiclesTableCompanion Function({
      Value<String> id,
      Value<String> typeId,
      Value<String> brand,
      Value<String> model,
      Value<int> year,
      Value<String> plate,
      Value<int> unit,
      Value<bool> isActive,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$VehiclesTableTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTableTable> {
  $$VehiclesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get typeId => $composableBuilder(
    column: $table.typeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VehiclesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTableTable> {
  $$VehiclesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeId => $composableBuilder(
    column: $table.typeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiclesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTableTable> {
  $$VehiclesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get typeId =>
      $composableBuilder(column: $table.typeId, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get plate =>
      $composableBuilder(column: $table.plate, builder: (column) => column);

  GeneratedColumn<int> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VehiclesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTableTable,
          VehiclesTableData,
          $$VehiclesTableTableFilterComposer,
          $$VehiclesTableTableOrderingComposer,
          $$VehiclesTableTableAnnotationComposer,
          $$VehiclesTableTableCreateCompanionBuilder,
          $$VehiclesTableTableUpdateCompanionBuilder,
          (
            VehiclesTableData,
            BaseReferences<
              _$AppDatabase,
              $VehiclesTableTable,
              VehiclesTableData
            >,
          ),
          VehiclesTableData,
          PrefetchHooks Function()
        > {
  $$VehiclesTableTableTableManager(_$AppDatabase db, $VehiclesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> typeId = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> plate = const Value.absent(),
                Value<int> unit = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesTableCompanion(
                id: id,
                typeId: typeId,
                brand: brand,
                model: model,
                year: year,
                plate: plate,
                unit: unit,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String typeId,
                required String brand,
                required String model,
                required int year,
                required String plate,
                required int unit,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesTableCompanion.insert(
                id: id,
                typeId: typeId,
                brand: brand,
                model: model,
                year: year,
                plate: plate,
                unit: unit,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VehiclesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTableTable,
      VehiclesTableData,
      $$VehiclesTableTableFilterComposer,
      $$VehiclesTableTableOrderingComposer,
      $$VehiclesTableTableAnnotationComposer,
      $$VehiclesTableTableCreateCompanionBuilder,
      $$VehiclesTableTableUpdateCompanionBuilder,
      (
        VehiclesTableData,
        BaseReferences<_$AppDatabase, $VehiclesTableTable, VehiclesTableData>,
      ),
      VehiclesTableData,
      PrefetchHooks Function()
    >;
typedef $$ReportsVehicleTableTableCreateCompanionBuilder =
    ReportsVehicleTableCompanion Function({
      required String id,
      required String vehicleId,
      required String responsibleId,
      required DateTime inspectionDate,
      required int mileage,
      Value<bool> requiresService,
      Value<String?> observation,
      Value<String?> generalNotes,
      required String folio,
      required String state,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$ReportsVehicleTableTableUpdateCompanionBuilder =
    ReportsVehicleTableCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String> responsibleId,
      Value<DateTime> inspectionDate,
      Value<int> mileage,
      Value<bool> requiresService,
      Value<String?> observation,
      Value<String?> generalNotes,
      Value<String> folio,
      Value<String> state,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$ReportsVehicleTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReportsVehicleTableTable> {
  $$ReportsVehicleTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responsibleId => $composableBuilder(
    column: $table.responsibleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get inspectionDate => $composableBuilder(
    column: $table.inspectionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mileage => $composableBuilder(
    column: $table.mileage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresService => $composableBuilder(
    column: $table.requiresService,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get generalNotes => $composableBuilder(
    column: $table.generalNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReportsVehicleTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportsVehicleTableTable> {
  $$ReportsVehicleTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responsibleId => $composableBuilder(
    column: $table.responsibleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get inspectionDate => $composableBuilder(
    column: $table.inspectionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mileage => $composableBuilder(
    column: $table.mileage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresService => $composableBuilder(
    column: $table.requiresService,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generalNotes => $composableBuilder(
    column: $table.generalNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReportsVehicleTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportsVehicleTableTable> {
  $$ReportsVehicleTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<String> get responsibleId => $composableBuilder(
    column: $table.responsibleId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get inspectionDate => $composableBuilder(
    column: $table.inspectionDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mileage =>
      $composableBuilder(column: $table.mileage, builder: (column) => column);

  GeneratedColumn<bool> get requiresService => $composableBuilder(
    column: $table.requiresService,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get generalNotes => $composableBuilder(
    column: $table.generalNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get folio =>
      $composableBuilder(column: $table.folio, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$ReportsVehicleTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportsVehicleTableTable,
          ReportsVehicleTableData,
          $$ReportsVehicleTableTableFilterComposer,
          $$ReportsVehicleTableTableOrderingComposer,
          $$ReportsVehicleTableTableAnnotationComposer,
          $$ReportsVehicleTableTableCreateCompanionBuilder,
          $$ReportsVehicleTableTableUpdateCompanionBuilder,
          (
            ReportsVehicleTableData,
            BaseReferences<
              _$AppDatabase,
              $ReportsVehicleTableTable,
              ReportsVehicleTableData
            >,
          ),
          ReportsVehicleTableData,
          PrefetchHooks Function()
        > {
  $$ReportsVehicleTableTableTableManager(
    _$AppDatabase db,
    $ReportsVehicleTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportsVehicleTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportsVehicleTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReportsVehicleTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> responsibleId = const Value.absent(),
                Value<DateTime> inspectionDate = const Value.absent(),
                Value<int> mileage = const Value.absent(),
                Value<bool> requiresService = const Value.absent(),
                Value<String?> observation = const Value.absent(),
                Value<String?> generalNotes = const Value.absent(),
                Value<String> folio = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsVehicleTableCompanion(
                id: id,
                vehicleId: vehicleId,
                responsibleId: responsibleId,
                inspectionDate: inspectionDate,
                mileage: mileage,
                requiresService: requiresService,
                observation: observation,
                generalNotes: generalNotes,
                folio: folio,
                state: state,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required String responsibleId,
                required DateTime inspectionDate,
                required int mileage,
                Value<bool> requiresService = const Value.absent(),
                Value<String?> observation = const Value.absent(),
                Value<String?> generalNotes = const Value.absent(),
                required String folio,
                required String state,
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsVehicleTableCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                responsibleId: responsibleId,
                inspectionDate: inspectionDate,
                mileage: mileage,
                requiresService: requiresService,
                observation: observation,
                generalNotes: generalNotes,
                folio: folio,
                state: state,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReportsVehicleTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportsVehicleTableTable,
      ReportsVehicleTableData,
      $$ReportsVehicleTableTableFilterComposer,
      $$ReportsVehicleTableTableOrderingComposer,
      $$ReportsVehicleTableTableAnnotationComposer,
      $$ReportsVehicleTableTableCreateCompanionBuilder,
      $$ReportsVehicleTableTableUpdateCompanionBuilder,
      (
        ReportsVehicleTableData,
        BaseReferences<
          _$AppDatabase,
          $ReportsVehicleTableTable,
          ReportsVehicleTableData
        >,
      ),
      ReportsVehicleTableData,
      PrefetchHooks Function()
    >;
typedef $$VehicleReportVersionsTableTableCreateCompanionBuilder =
    VehicleReportVersionsTableCompanion Function({
      required String id,
      required String reportId,
      required int versionNumber,
      required bool isCurrent,
      required String createdBy,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$VehicleReportVersionsTableTableUpdateCompanionBuilder =
    VehicleReportVersionsTableCompanion Function({
      Value<String> id,
      Value<String> reportId,
      Value<int> versionNumber,
      Value<bool> isCurrent,
      Value<String> createdBy,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$VehicleReportVersionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $VehicleReportVersionsTableTable> {
  $$VehicleReportVersionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportId => $composableBuilder(
    column: $table.reportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VehicleReportVersionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VehicleReportVersionsTableTable> {
  $$VehicleReportVersionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportId => $composableBuilder(
    column: $table.reportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCurrent => $composableBuilder(
    column: $table.isCurrent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehicleReportVersionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehicleReportVersionsTableTable> {
  $$VehicleReportVersionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reportId =>
      $composableBuilder(column: $table.reportId, builder: (column) => column);

  GeneratedColumn<int> get versionNumber => $composableBuilder(
    column: $table.versionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCurrent =>
      $composableBuilder(column: $table.isCurrent, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VehicleReportVersionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehicleReportVersionsTableTable,
          VehicleReportVersionsTableData,
          $$VehicleReportVersionsTableTableFilterComposer,
          $$VehicleReportVersionsTableTableOrderingComposer,
          $$VehicleReportVersionsTableTableAnnotationComposer,
          $$VehicleReportVersionsTableTableCreateCompanionBuilder,
          $$VehicleReportVersionsTableTableUpdateCompanionBuilder,
          (
            VehicleReportVersionsTableData,
            BaseReferences<
              _$AppDatabase,
              $VehicleReportVersionsTableTable,
              VehicleReportVersionsTableData
            >,
          ),
          VehicleReportVersionsTableData,
          PrefetchHooks Function()
        > {
  $$VehicleReportVersionsTableTableTableManager(
    _$AppDatabase db,
    $VehicleReportVersionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehicleReportVersionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$VehicleReportVersionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$VehicleReportVersionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> reportId = const Value.absent(),
                Value<int> versionNumber = const Value.absent(),
                Value<bool> isCurrent = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehicleReportVersionsTableCompanion(
                id: id,
                reportId: reportId,
                versionNumber: versionNumber,
                isCurrent: isCurrent,
                createdBy: createdBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String reportId,
                required int versionNumber,
                required bool isCurrent,
                required String createdBy,
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehicleReportVersionsTableCompanion.insert(
                id: id,
                reportId: reportId,
                versionNumber: versionNumber,
                isCurrent: isCurrent,
                createdBy: createdBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VehicleReportVersionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehicleReportVersionsTableTable,
      VehicleReportVersionsTableData,
      $$VehicleReportVersionsTableTableFilterComposer,
      $$VehicleReportVersionsTableTableOrderingComposer,
      $$VehicleReportVersionsTableTableAnnotationComposer,
      $$VehicleReportVersionsTableTableCreateCompanionBuilder,
      $$VehicleReportVersionsTableTableUpdateCompanionBuilder,
      (
        VehicleReportVersionsTableData,
        BaseReferences<
          _$AppDatabase,
          $VehicleReportVersionsTableTable,
          VehicleReportVersionsTableData
        >,
      ),
      VehicleReportVersionsTableData,
      PrefetchHooks Function()
    >;
typedef $$ReportAnswersVehicleTableTableCreateCompanionBuilder =
    ReportAnswersVehicleTableCompanion Function({
      required String id,
      required String reportVersionId,
      required String componentId,
      required String optionId,
      Value<String?> observation,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ReportAnswersVehicleTableTableUpdateCompanionBuilder =
    ReportAnswersVehicleTableCompanion Function({
      Value<String> id,
      Value<String> reportVersionId,
      Value<String> componentId,
      Value<String> optionId,
      Value<String?> observation,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ReportAnswersVehicleTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReportAnswersVehicleTableTable> {
  $$ReportAnswersVehicleTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportVersionId => $composableBuilder(
    column: $table.reportVersionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionId => $composableBuilder(
    column: $table.optionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReportAnswersVehicleTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportAnswersVehicleTableTable> {
  $$ReportAnswersVehicleTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportVersionId => $composableBuilder(
    column: $table.reportVersionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionId => $composableBuilder(
    column: $table.optionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReportAnswersVehicleTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportAnswersVehicleTableTable> {
  $$ReportAnswersVehicleTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reportVersionId => $composableBuilder(
    column: $table.reportVersionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get componentId => $composableBuilder(
    column: $table.componentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get optionId =>
      $composableBuilder(column: $table.optionId, builder: (column) => column);

  GeneratedColumn<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReportAnswersVehicleTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportAnswersVehicleTableTable,
          ReportAnswersVehicleTableData,
          $$ReportAnswersVehicleTableTableFilterComposer,
          $$ReportAnswersVehicleTableTableOrderingComposer,
          $$ReportAnswersVehicleTableTableAnnotationComposer,
          $$ReportAnswersVehicleTableTableCreateCompanionBuilder,
          $$ReportAnswersVehicleTableTableUpdateCompanionBuilder,
          (
            ReportAnswersVehicleTableData,
            BaseReferences<
              _$AppDatabase,
              $ReportAnswersVehicleTableTable,
              ReportAnswersVehicleTableData
            >,
          ),
          ReportAnswersVehicleTableData,
          PrefetchHooks Function()
        > {
  $$ReportAnswersVehicleTableTableTableManager(
    _$AppDatabase db,
    $ReportAnswersVehicleTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportAnswersVehicleTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ReportAnswersVehicleTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReportAnswersVehicleTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> reportVersionId = const Value.absent(),
                Value<String> componentId = const Value.absent(),
                Value<String> optionId = const Value.absent(),
                Value<String?> observation = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportAnswersVehicleTableCompanion(
                id: id,
                reportVersionId: reportVersionId,
                componentId: componentId,
                optionId: optionId,
                observation: observation,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String reportVersionId,
                required String componentId,
                required String optionId,
                Value<String?> observation = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ReportAnswersVehicleTableCompanion.insert(
                id: id,
                reportVersionId: reportVersionId,
                componentId: componentId,
                optionId: optionId,
                observation: observation,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReportAnswersVehicleTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportAnswersVehicleTableTable,
      ReportAnswersVehicleTableData,
      $$ReportAnswersVehicleTableTableFilterComposer,
      $$ReportAnswersVehicleTableTableOrderingComposer,
      $$ReportAnswersVehicleTableTableAnnotationComposer,
      $$ReportAnswersVehicleTableTableCreateCompanionBuilder,
      $$ReportAnswersVehicleTableTableUpdateCompanionBuilder,
      (
        ReportAnswersVehicleTableData,
        BaseReferences<
          _$AppDatabase,
          $ReportAnswersVehicleTableTable,
          ReportAnswersVehicleTableData
        >,
      ),
      ReportAnswersVehicleTableData,
      PrefetchHooks Function()
    >;
typedef $$EvidenceVehicleTableTableCreateCompanionBuilder =
    EvidenceVehicleTableCompanion Function({
      required String id,
      required String answerId,
      required String filePath,
      required String fileType,
      required String mimeType,
      Value<int?> fileSize,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$EvidenceVehicleTableTableUpdateCompanionBuilder =
    EvidenceVehicleTableCompanion Function({
      Value<String> id,
      Value<String> answerId,
      Value<String> filePath,
      Value<String> fileType,
      Value<String> mimeType,
      Value<int?> fileSize,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$EvidenceVehicleTableTableFilterComposer
    extends Composer<_$AppDatabase, $EvidenceVehicleTableTable> {
  $$EvidenceVehicleTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerId => $composableBuilder(
    column: $table.answerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EvidenceVehicleTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EvidenceVehicleTableTable> {
  $$EvidenceVehicleTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerId => $composableBuilder(
    column: $table.answerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileType => $composableBuilder(
    column: $table.fileType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EvidenceVehicleTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EvidenceVehicleTableTable> {
  $$EvidenceVehicleTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get answerId =>
      $composableBuilder(column: $table.answerId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EvidenceVehicleTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EvidenceVehicleTableTable,
          EvidenceVehicleTableData,
          $$EvidenceVehicleTableTableFilterComposer,
          $$EvidenceVehicleTableTableOrderingComposer,
          $$EvidenceVehicleTableTableAnnotationComposer,
          $$EvidenceVehicleTableTableCreateCompanionBuilder,
          $$EvidenceVehicleTableTableUpdateCompanionBuilder,
          (
            EvidenceVehicleTableData,
            BaseReferences<
              _$AppDatabase,
              $EvidenceVehicleTableTable,
              EvidenceVehicleTableData
            >,
          ),
          EvidenceVehicleTableData,
          PrefetchHooks Function()
        > {
  $$EvidenceVehicleTableTableTableManager(
    _$AppDatabase db,
    $EvidenceVehicleTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EvidenceVehicleTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EvidenceVehicleTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EvidenceVehicleTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> answerId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> fileType = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<int?> fileSize = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EvidenceVehicleTableCompanion(
                id: id,
                answerId: answerId,
                filePath: filePath,
                fileType: fileType,
                mimeType: mimeType,
                fileSize: fileSize,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String answerId,
                required String filePath,
                required String fileType,
                required String mimeType,
                Value<int?> fileSize = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => EvidenceVehicleTableCompanion.insert(
                id: id,
                answerId: answerId,
                filePath: filePath,
                fileType: fileType,
                mimeType: mimeType,
                fileSize: fileSize,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EvidenceVehicleTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EvidenceVehicleTableTable,
      EvidenceVehicleTableData,
      $$EvidenceVehicleTableTableFilterComposer,
      $$EvidenceVehicleTableTableOrderingComposer,
      $$EvidenceVehicleTableTableAnnotationComposer,
      $$EvidenceVehicleTableTableCreateCompanionBuilder,
      $$EvidenceVehicleTableTableUpdateCompanionBuilder,
      (
        EvidenceVehicleTableData,
        BaseReferences<
          _$AppDatabase,
          $EvidenceVehicleTableTable,
          EvidenceVehicleTableData
        >,
      ),
      EvidenceVehicleTableData,
      PrefetchHooks Function()
    >;
typedef $$PendingVehicleReportsTableTableCreateCompanionBuilder =
    PendingVehicleReportsTableCompanion Function({
      required String id,
      required String vehicleId,
      required String folio,
      required String payload,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });
typedef $$PendingVehicleReportsTableTableUpdateCompanionBuilder =
    PendingVehicleReportsTableCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String> folio,
      Value<String> payload,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<DateTime?> syncedAt,
      Value<int> rowid,
    });

class $$PendingVehicleReportsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingVehicleReportsTableTable> {
  $$PendingVehicleReportsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingVehicleReportsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingVehicleReportsTableTable> {
  $$PendingVehicleReportsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingVehicleReportsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingVehicleReportsTableTable> {
  $$PendingVehicleReportsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<String> get folio =>
      $composableBuilder(column: $table.folio, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$PendingVehicleReportsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingVehicleReportsTableTable,
          PendingVehicleReportsTableData,
          $$PendingVehicleReportsTableTableFilterComposer,
          $$PendingVehicleReportsTableTableOrderingComposer,
          $$PendingVehicleReportsTableTableAnnotationComposer,
          $$PendingVehicleReportsTableTableCreateCompanionBuilder,
          $$PendingVehicleReportsTableTableUpdateCompanionBuilder,
          (
            PendingVehicleReportsTableData,
            BaseReferences<
              _$AppDatabase,
              $PendingVehicleReportsTableTable,
              PendingVehicleReportsTableData
            >,
          ),
          PendingVehicleReportsTableData,
          PrefetchHooks Function()
        > {
  $$PendingVehicleReportsTableTableTableManager(
    _$AppDatabase db,
    $PendingVehicleReportsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingVehicleReportsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PendingVehicleReportsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingVehicleReportsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> folio = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingVehicleReportsTableCompanion(
                id: id,
                vehicleId: vehicleId,
                folio: folio,
                payload: payload,
                isSynced: isSynced,
                createdAt: createdAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required String folio,
                required String payload,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingVehicleReportsTableCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                folio: folio,
                payload: payload,
                isSynced: isSynced,
                createdAt: createdAt,
                syncedAt: syncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingVehicleReportsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingVehicleReportsTableTable,
      PendingVehicleReportsTableData,
      $$PendingVehicleReportsTableTableFilterComposer,
      $$PendingVehicleReportsTableTableOrderingComposer,
      $$PendingVehicleReportsTableTableAnnotationComposer,
      $$PendingVehicleReportsTableTableCreateCompanionBuilder,
      $$PendingVehicleReportsTableTableUpdateCompanionBuilder,
      (
        PendingVehicleReportsTableData,
        BaseReferences<
          _$AppDatabase,
          $PendingVehicleReportsTableTable,
          PendingVehicleReportsTableData
        >,
      ),
      PendingVehicleReportsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableTableManager get vehiclesTable =>
      $$VehiclesTableTableTableManager(_db, _db.vehiclesTable);
  $$ReportsVehicleTableTableTableManager get reportsVehicleTable =>
      $$ReportsVehicleTableTableTableManager(_db, _db.reportsVehicleTable);
  $$VehicleReportVersionsTableTableTableManager
  get vehicleReportVersionsTable =>
      $$VehicleReportVersionsTableTableTableManager(
        _db,
        _db.vehicleReportVersionsTable,
      );
  $$ReportAnswersVehicleTableTableTableManager get reportAnswersVehicleTable =>
      $$ReportAnswersVehicleTableTableTableManager(
        _db,
        _db.reportAnswersVehicleTable,
      );
  $$EvidenceVehicleTableTableTableManager get evidenceVehicleTable =>
      $$EvidenceVehicleTableTableTableManager(_db, _db.evidenceVehicleTable);
  $$PendingVehicleReportsTableTableTableManager
  get pendingVehicleReportsTable =>
      $$PendingVehicleReportsTableTableTableManager(
        _db,
        _db.pendingVehicleReportsTable,
      );
}
