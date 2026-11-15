// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get tabToday => 'Hoje';

  @override
  String get tabReminders => 'Lembretes';

  @override
  String get webPreviewNotice =>
      'Esta é uma prévia na web, por isso nenhuma notificação é enviada. Elas só funcionam no app do celular.';

  @override
  String get notificationsOffNotice =>
      'As notificações estão desativadas. Ative-as para este app nos Ajustes do celular para receber lembretes.';

  @override
  String get emptyNoRemindersTitle => 'Ainda não há lembretes';

  @override
  String get emptyNoRemindersBody =>
      'Escolha alguns lembretes prontos e ative-os. Só isso.';

  @override
  String get emptyBrowseAction => 'Ver lembretes prontos';

  @override
  String get emptyNothingTodayTitle => 'Nada para hoje';

  @override
  String get emptyNothingTodayBody => 'Seus lembretes caem em outros dias.';

  @override
  String get ringDone => 'feitos';

  @override
  String ringSemantics(int done, int total) {
    return '$done de $total feitos hoje';
  }

  @override
  String get summaryAllDoneTitle => 'Tudo feito!';

  @override
  String get summaryAllDoneBody => 'Você não esqueceu nada hoje.';

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
  String get summaryOverdueBody =>
      'Toque em um círculo para marcar como feito.';

  @override
  String summaryNextTitle(String time) {
    return 'Próximo às $time';
  }

  @override
  String get sectionTodo => 'A fazer';

  @override
  String get sectionDone => 'Feito';

  @override
  String itemOverdue(String time) {
    return '$time · atrasado';
  }

  @override
  String itemAt(String title, String time) {
    return '$title às $time';
  }

  @override
  String activeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lembretes ativos',
      one: '1 lembrete ativo',
    );
    return '$_temp0';
  }

  @override
  String get createOwn => 'Criar seu próprio lembrete';

  @override
  String get groupMine => 'Meus';

  @override
  String get tooManyNotifications =>
      'Horários de lembrete demais. Desative um lembrete ou use menos horários.';

  @override
  String get editNewTitle => 'Novo lembrete';

  @override
  String get editEditTitle => 'Editar lembrete';

  @override
  String get fieldTitleLabel => 'Lembrar o quê?';

  @override
  String get fieldTitleHint => 'Por exemplo: Dar comida ao gato';

  @override
  String get labelRepeat => 'Repetir';

  @override
  String get repeatDaily => 'Diário';

  @override
  String get repeatWeekly => 'Semanal';

  @override
  String get repeatMonthly => 'Mensal';

  @override
  String get labelOnDays => 'Nestes dias';

  @override
  String get labelOnDay => 'No dia';

  @override
  String dayOfMonthOption(int day) {
    return 'Dia $day de cada mês';
  }

  @override
  String get dayOfMonthHelper =>
      'Só até o dia 28, porque todo mês tem esse dia.';

  @override
  String get labelTimes => 'Horários';

  @override
  String removeTime(String time) {
    return 'Remover $time';
  }

  @override
  String get addTime => 'Adicionar horário';

  @override
  String get pickTimeHelp => 'Escolha um horário';

  @override
  String get save => 'Salvar';

  @override
  String get turnOffReminder => 'Desativar este lembrete';

  @override
  String get deleteReminder => 'Excluir este lembrete';

  @override
  String get errorNoTitle => 'Dê um nome ao lembrete.';

  @override
  String get errorNoTimes => 'Adicione pelo menos um horário.';

  @override
  String get errorNoWeekdays => 'Escolha pelo menos um dia da semana.';

  @override
  String get scheduleEveryDay => 'Todo dia';

  @override
  String scheduleManyTimes(int count, String first, String last) {
    return '$count vezes ($first–$last)';
  }

  @override
  String customMessage(String title) {
    return 'Está na hora: $title';
  }

  @override
  String get notifChannelName => 'Lembretes';

  @override
  String get notifChannelDescription => 'Os lembretes que você ativou';

  @override
  String get actionDone => 'Feito';

  @override
  String actionSnooze(int minutes) {
    return 'Lembrar em $minutes min';
  }
}
