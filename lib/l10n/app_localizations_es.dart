// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get tabToday => 'Hoy';

  @override
  String get tabReminders => 'Recordatorios';

  @override
  String get webPreviewNotice =>
      'Esta es una vista previa web, así que no se envían notificaciones. Solo funcionan en la app del teléfono.';

  @override
  String get notificationsOffNotice =>
      'Las notificaciones están desactivadas. Actívalas para esta app en los Ajustes del teléfono para recibir recordatorios.';

  @override
  String get emptyNoRemindersTitle => 'Aún no hay recordatorios';

  @override
  String get emptyNoRemindersBody =>
      'Elige algunos recordatorios ya preparados y actívalos. Nada más.';

  @override
  String get emptyBrowseAction => 'Ver recordatorios preparados';

  @override
  String get emptyNothingTodayTitle => 'Nada para hoy';

  @override
  String get emptyNothingTodayBody => 'Tus recordatorios caen en otros días.';

  @override
  String get ringDone => 'hechos';

  @override
  String ringSemantics(int done, int total) {
    return '$done de $total hechos hoy';
  }

  @override
  String get summaryAllDoneTitle => '¡Todo hecho!';

  @override
  String get summaryAllDoneBody => 'Hoy no has olvidado nada.';

  @override
  String summaryOverdueTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count atrasados',
      one: '1 atrasado',
    );
    return '$_temp0';
  }

  @override
  String get summaryOverdueBody => 'Toca un círculo para marcarlo como hecho.';

  @override
  String summaryNextTitle(String time) {
    return 'Siguiente a las $time';
  }

  @override
  String get sectionTodo => 'Por hacer';

  @override
  String get sectionDone => 'Hecho';

  @override
  String itemOverdue(String time) {
    return '$time · atrasado';
  }

  @override
  String itemAt(String title, String time) {
    return '$title a las $time';
  }

  @override
  String activeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recordatorios activos',
      one: '1 recordatorio activo',
    );
    return '$_temp0';
  }

  @override
  String get createOwn => 'Crear tu propio recordatorio';

  @override
  String get groupMine => 'Míos';

  @override
  String get tooManyNotifications =>
      'Demasiadas horas de recordatorio. Desactiva un recordatorio o usa menos horas.';

  @override
  String get editNewTitle => 'Nuevo recordatorio';

  @override
  String get editEditTitle => 'Editar recordatorio';

  @override
  String get fieldTitleLabel => '¿Qué recordar?';

  @override
  String get fieldTitleHint => 'Por ejemplo: Dar de comer al gato';

  @override
  String get labelIcon => 'Icono';

  @override
  String get labelRepeat => 'Repetir';

  @override
  String get repeatDaily => 'Diario';

  @override
  String get repeatWeekly => 'Semanal';

  @override
  String get repeatMonthly => 'Mensual';

  @override
  String get labelOnDays => 'Estos días';

  @override
  String get labelOnDay => 'El día';

  @override
  String dayOfMonthOption(int day) {
    return 'Día $day de cada mes';
  }

  @override
  String get dayOfMonthHelper =>
      'Solo hasta el día 28, porque todos los meses lo tienen.';

  @override
  String get labelTimes => 'Horas';

  @override
  String removeTime(String time) {
    return 'Quitar $time';
  }

  @override
  String get addTime => 'Añadir hora';

  @override
  String get pickTimeHelp => 'Elige una hora';

  @override
  String get save => 'Guardar';

  @override
  String get turnOffReminder => 'Desactivar este recordatorio';

  @override
  String get deleteReminder => 'Eliminar este recordatorio';

  @override
  String get errorNoTitle => 'Ponle un nombre al recordatorio.';

  @override
  String get errorNoTimes => 'Añade al menos una hora.';

  @override
  String get errorNoWeekdays => 'Elige al menos un día de la semana.';

  @override
  String get scheduleEveryDay => 'Cada día';

  @override
  String scheduleManyTimes(int count, String first, String last) {
    return '$count veces ($first–$last)';
  }

  @override
  String customMessage(String title) {
    return 'Es la hora: $title';
  }

  @override
  String get notifChannelName => 'Recordatorios';

  @override
  String get notifChannelDescription => 'Los recordatorios que activaste';

  @override
  String get actionDone => 'Hecho';

  @override
  String actionSnooze(int minutes) {
    return 'Recordar en $minutes min';
  }
}
