import 'package:api_client/api_client.dart';
import 'package:design_system/design_system.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/app_providers.dart';

class ShopScheduleCreateView extends ConsumerStatefulWidget {
  const ShopScheduleCreateView({
    super.key,
    required this.shopId,
    this.initialScheduleId,
    this.initialShopMemberId,
    this.initialWorkDate,
    this.initialStartTime,
    this.initialEndTime,
    this.initialRepeatGroupKey,
  });

  final int shopId;
  final int? initialScheduleId;
  final int? initialShopMemberId;
  final DateTime? initialWorkDate;
  final String? initialStartTime;
  final String? initialEndTime;
  final String? initialRepeatGroupKey;

  @override
  ConsumerState<ShopScheduleCreateView> createState() =>
      _ShopScheduleCreateViewState();
}

class _ShopScheduleCreateViewState
    extends ConsumerState<ShopScheduleCreateView> {
  static const _weekdayOptions = <({String value, String label})>[
    (value: 'MONDAY', label: '월'),
    (value: 'TUESDAY', label: '화'),
    (value: 'WEDNESDAY', label: '수'),
    (value: 'THURSDAY', label: '목'),
    (value: 'FRIDAY', label: '금'),
    (value: 'SATURDAY', label: '토'),
    (value: 'SUNDAY', label: '일'),
  ];
  static const _fallbackPresetDurations = <int>[4, 6, 8];

  int? _selectedMemberId;
  DateTime _workDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 18, minute: 0);
  bool _repeatWeekly = false;
  DateTime? _repeatUntil;
  final Set<String> _repeatDays = <String>{};
  bool _showOnlyOverlappingSchedules = true;
  bool _isSubmitting = false;
  int? _cancellingScheduleId;
  bool _isBulkCancelling = false;
  int? _editingScheduleId;
  String? _editingRepeatGroupKey;
  String _editingScope = 'THIS_ONLY';
  bool _isInlineEditing = false;

  @override
  void initState() {
    super.initState();
    _selectedMemberId = widget.initialShopMemberId;
    if (widget.initialWorkDate != null) {
      _workDate = _dateOnly(widget.initialWorkDate!);
    }
    if (widget.initialStartTime != null) {
      _startTime = _parseTimeOfDay(widget.initialStartTime!);
    }
    if (widget.initialEndTime != null) {
      _endTime = _parseTimeOfDay(widget.initialEndTime!);
    }
    _editingScheduleId = widget.initialScheduleId;
    _editingRepeatGroupKey = widget.initialRepeatGroupKey;
    _isInlineEditing = false;
  }

  ({int shopId, int? shopMemberId, DateTime startDate, DateTime endDate})?
  get _scheduleRangeParams {
    if (_selectedMemberId == null) {
      return null;
    }
    return (
      shopId: widget.shopId,
      shopMemberId: _selectedMemberId,
      startDate: _workDate,
      endDate: _repeatWeekly && _repeatUntil != null
          ? _repeatUntil!
          : _workDate,
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}.$month.$day';
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatTimeRangeFromStrings(String startTime, String endTime) {
    return '${startTime.substring(0, 5)} ~ ${endTime.substring(0, 5)}';
  }

  TimeOfDay _parseTimeOfDay(String value) {
    final parts = value.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatPresetLabel(TimeOfDay startTime, TimeOfDay endTime) {
    return '${_formatTime(startTime)} ~ ${_formatTime(endTime)}';
  }

  List<({String label, TimeOfDay startTime, TimeOfDay endTime})>
  _buildFallbackDurationPresets() {
    final fallbackPresets =
        <({String label, TimeOfDay startTime, TimeOfDay endTime})>[];
    for (final duration in _fallbackPresetDurations) {
      final endMinutes =
          _startTime.hour * 60 + _startTime.minute + duration * 60;
      if (endMinutes >= 24 * 60) {
        continue;
      }
      final endTime = TimeOfDay(
        hour: endMinutes ~/ 60,
        minute: endMinutes % 60,
      );
      fallbackPresets.add((
        label: '$duration시간',
        startTime: _startTime,
        endTime: endTime,
      ));
    }
    return fallbackPresets;
  }

  List<({String label, TimeOfDay startTime, TimeOfDay endTime})>
  _buildSchedulePresets(List<ScheduleSummaryResponse> schedules) {
    final uniquePresets =
        schedules.where((schedule) => schedule.status == 'SCHEDULED').toList()
          ..sort((left, right) {
            final rightDate = right.workDate ?? _workDate;
            final leftDate = left.workDate ?? _workDate;
            final dateCompare = rightDate.compareTo(leftDate);
            if (dateCompare != 0) {
              return dateCompare;
            }
            return right.startTime.compareTo(left.startTime);
          });

    final presets =
        <({String label, TimeOfDay startTime, TimeOfDay endTime})>[];
    final seen = <String>{};
    for (final schedule in uniquePresets) {
      final key = '${schedule.startTime}-${schedule.endTime}';
      if (!seen.add(key)) {
        continue;
      }
      final startTime = _parseTimeOfDay(schedule.startTime);
      final endTime = _parseTimeOfDay(schedule.endTime);
      presets.add((
        label: _formatPresetLabel(startTime, endTime),
        startTime: startTime,
        endTime: endTime,
      ));
      if (presets.length == 3) {
        break;
      }
    }
    if (presets.isNotEmpty) {
      return presets;
    }
    return _buildFallbackDurationPresets();
  }

  String _resolveApiErrorMessage(
    DioException error, {
    required String fallback,
  }) {
    final data = error.response?.data;
    if (data is Map) {
      final responseMessage = data['message'];
      final errorMessage = data['error'];
      if (responseMessage is String && responseMessage.isNotEmpty) {
        return responseMessage;
      }
      if (errorMessage is String && errorMessage.isNotEmpty) {
        return errorMessage;
      }
    }
    return fallback;
  }

  bool _matchesRepeatRule(DateTime date) {
    final targetDate = _dateOnly(date);
    final workDate = _dateOnly(_workDate);
    if (!_repeatWeekly) {
      return targetDate.year == workDate.year &&
          targetDate.month == workDate.month &&
          targetDate.day == workDate.day;
    }
    if (targetDate.isBefore(workDate) ||
        (_repeatUntil != null &&
            targetDate.isAfter(_dateOnly(_repeatUntil!)))) {
      return false;
    }
    if (_repeatDays.isEmpty) {
      return false;
    }
    const dayMap = {
      1: 'MONDAY',
      2: 'TUESDAY',
      3: 'WEDNESDAY',
      4: 'THURSDAY',
      5: 'FRIDAY',
      6: 'SATURDAY',
      7: 'SUNDAY',
    };
    return _repeatDays.contains(dayMap[date.weekday]);
  }

  bool _isTimeOverlapping(ScheduleSummaryResponse schedule) {
    if (_editingScheduleId == schedule.no) {
      return false;
    }
    final currentStartMinutes = _startTime.hour * 60 + _startTime.minute;
    final currentEndMinutes = _endTime.hour * 60 + _endTime.minute;
    final scheduleStart = schedule.startTime.split(':');
    final scheduleEnd = schedule.endTime.split(':');
    if (scheduleStart.length < 2 || scheduleEnd.length < 2) {
      return false;
    }
    final scheduleStartMinutes =
        int.parse(scheduleStart[0]) * 60 + int.parse(scheduleStart[1]);
    final scheduleEndMinutes =
        int.parse(scheduleEnd[0]) * 60 + int.parse(scheduleEnd[1]);
    return currentStartMinutes < scheduleEndMinutes &&
        currentEndMinutes > scheduleStartMinutes;
  }

  Future<void> _pickWorkDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _workDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _workDate = DateTime(picked.year, picked.month, picked.day);
      if (!_repeatWeekly) {
        _repeatUntil = null;
        _repeatDays.clear();
      }
    });
    _invalidateScheduleQueries();
  }

  Future<void> _pickRepeatUntil() async {
    final initialDate = _repeatUntil ?? _workDate.add(const Duration(days: 7));
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: _workDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _repeatUntil = DateTime(picked.year, picked.month, picked.day);
    });
    _invalidateScheduleQueries();
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) {
      return;
    }
    setState(() {
      if (isStart) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });
  }

  void _onMemberChanged(int? value) {
    setState(() {
      _selectedMemberId = value;
      _editingScheduleId = null;
      _editingRepeatGroupKey = null;
      _editingScope = 'THIS_ONLY';
      _isInlineEditing = false;
    });
    _invalidateScheduleQueries();
  }

  void _onRepeatWeeklyChanged(bool value) {
    setState(() {
      _repeatWeekly = value;
      if (value) {
        _repeatDays.add(_weekdayOptions[_workDate.weekday - 1].value);
      } else {
        _repeatUntil = null;
        _repeatDays.clear();
      }
    });
    _invalidateScheduleQueries();
  }

  void _onRepeatDayChanged(String dayValue, bool selected) {
    setState(() {
      if (selected) {
        _repeatDays.add(dayValue);
      } else {
        _repeatDays.remove(dayValue);
      }
    });
    _invalidateScheduleQueries();
  }

  void _startEditingSchedule(ScheduleSummaryResponse schedule) {
    final workDate = schedule.workDate;
    if (workDate == null) {
      return;
    }
    setState(() {
      _editingScheduleId = schedule.no;
      _editingRepeatGroupKey = schedule.repeatGroupKey;
      _editingScope = 'THIS_ONLY';
      _isInlineEditing = true;
      _workDate = _dateOnly(workDate);
      _startTime = _parseTimeOfDay(schedule.startTime);
      _endTime = _parseTimeOfDay(schedule.endTime);
      _repeatWeekly = false;
      _repeatUntil = null;
      _repeatDays.clear();
    });
    _invalidateScheduleQueries();
  }

  void _stopEditingSchedule() {
    setState(() {
      _editingScheduleId = null;
      _editingRepeatGroupKey = null;
      _editingScope = 'THIS_ONLY';
      _isInlineEditing = false;
    });
    _invalidateScheduleQueries();
  }

  bool _validate() {
    if (_selectedMemberId == null) {
      _showSnackBar('직원을 먼저 선택해주세요.');
      return false;
    }

    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    if (endMinutes <= startMinutes) {
      _showSnackBar('종료 시간은 시작 시간보다 늦어야 합니다.');
      return false;
    }

    if (_repeatWeekly) {
      if (_repeatUntil == null) {
        _showSnackBar('반복 종료일을 선택해주세요.');
        return false;
      }
      if (_repeatUntil!.isBefore(_workDate)) {
        _showSnackBar('반복 종료일은 시작일 이후여야 합니다.');
        return false;
      }
      if (_repeatDays.isEmpty) {
        _showSnackBar('반복할 요일을 하나 이상 선택해주세요.');
        return false;
      }
    }

    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  void _invalidateScheduleQueries() {
    final params = _scheduleRangeParams;
    if (params == null) {
      return;
    }
    ref.invalidate(shopScheduleRangeProvider(params));
    ref.invalidate(
      shopSchedulesProvider((
        shopId: widget.shopId,
        shopMemberId: _selectedMemberId,
        baseDate: _workDate,
        viewType: 'MONTH',
      )),
    );
    ref.invalidate(
      shopSchedulesProvider((
        shopId: widget.shopId,
        shopMemberId: null,
        baseDate: _workDate,
        viewType: 'MONTH',
      )),
    );
  }

  Future<void> _submit() async {
    if (!_validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (_editingScheduleId != null) {
        await ref
            .read(shopServiceProvider)
            .editSchedule(
              widget.shopId,
              _editingScheduleId!,
              EditScheduleRequest(
                workDate: _workDate,
                startTime: '${_formatTime(_startTime)}:00',
                endTime: '${_formatTime(_endTime)}:00',
                scope: _editingScope,
              ),
            );
      } else {
        await ref
            .read(shopServiceProvider)
            .createSchedules(
              widget.shopId,
              CreateScheduleRequest(
                shopMemberId: _selectedMemberId!,
                workDate: _workDate,
                startTime: '${_formatTime(_startTime)}:00',
                endTime: '${_formatTime(_endTime)}:00',
                repeatUntil: _repeatWeekly ? _repeatUntil : null,
                repeatDaysOfWeek: _repeatWeekly ? _repeatDays.toList() : null,
              ),
            );
      }
      _invalidateScheduleQueries();
      if (!mounted) {
        return;
      }
      if (_editingScheduleId != null) {
        final successMessage = switch (_editingScope) {
          'ALL' => '반복 일정 전체가 수정되었습니다.',
          'FOLLOWING' => '선택한 일정 이후 반복이 수정되었습니다.',
          _ => '일정이 수정되었습니다.',
        };
        _showSnackBar(successMessage);
        _stopEditingSchedule();
      } else {
        _showSnackBar('일정이 등록되었습니다.');
        Navigator.of(context).pop();
      }
    } on DioException catch (error) {
      final message = _resolveApiErrorMessage(
        error,
        fallback: _editingScheduleId == null
            ? '일정 등록에 실패했습니다.'
            : '일정 수정에 실패했습니다.',
      );
      _invalidateScheduleQueries();
      if (mounted) {
        _showSnackBar(message);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _cancelSchedule(ScheduleSummaryResponse schedule) async {
    setState(() {
      _cancellingScheduleId = schedule.no;
    });
    try {
      await ref
          .read(shopServiceProvider)
          .cancelSchedule(widget.shopId, schedule.no);
      _invalidateScheduleQueries();
      if (mounted) {
        _showSnackBar('기존 일정이 취소되었습니다. 새 일정으로 다시 등록하세요.');
      }
    } on DioException catch (error) {
      final message = _resolveApiErrorMessage(
        error,
        fallback: '일정 취소에 실패했습니다.',
      );
      if (mounted) {
        _showSnackBar(message);
      }
    } finally {
      if (mounted) {
        setState(() {
          _cancellingScheduleId = null;
        });
      }
    }
  }

  Future<void> _cancelSchedules(List<ScheduleSummaryResponse> schedules) async {
    setState(() {
      _isBulkCancelling = true;
    });
    try {
      final service = ref.read(shopServiceProvider);
      for (final schedule in schedules) {
        await service.cancelSchedule(widget.shopId, schedule.no);
      }
      _invalidateScheduleQueries();
      if (mounted) {
        _showSnackBar('선택 범위의 기존 일정이 취소되었습니다. 새 일정으로 다시 등록하세요.');
      }
    } on DioException catch (error) {
      final message = _resolveApiErrorMessage(
        error,
        fallback: '일괄 일정 취소에 실패했습니다.',
      );
      if (mounted) {
        _showSnackBar(message);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBulkCancelling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(activeShopMembersProvider(widget.shopId));
    final monthlyPresetSchedules = _selectedMemberId == null
        ? null
        : ref.watch(
            shopSchedulesProvider((
              shopId: widget.shopId,
              shopMemberId: _selectedMemberId,
              baseDate: _workDate,
              viewType: 'MONTH',
            )),
          );
    final monthlyShopPresetSchedules = ref.watch(
      shopSchedulesProvider((
        shopId: widget.shopId,
        shopMemberId: null,
        baseDate: _workDate,
        viewType: 'MONTH',
      )),
    );
    final scheduleRangeParams = _scheduleRangeParams;
    final selectedRangeSchedules = scheduleRangeParams == null
        ? null
        : ref.watch(shopScheduleRangeProvider(scheduleRangeParams));
    final matchedSchedules = selectedRangeSchedules?.when(
      loading: () => const <ScheduleSummaryResponse>[],
      error: (error, stackTrace) => const <ScheduleSummaryResponse>[],
      data: (items) =>
          items.where((item) {
            final workDate = item.workDate;
            return workDate != null &&
                item.status == 'SCHEDULED' &&
                _matchesRepeatRule(workDate);
          }).toList()..sort((left, right) {
            final leftDate = left.workDate ?? _workDate;
            final rightDate = right.workDate ?? _workDate;
            final dateCompare = leftDate.compareTo(rightDate);
            if (dateCompare != 0) {
              return dateCompare;
            }
            return left.startTime.compareTo(right.startTime);
          }),
    );
    final overlappingSchedules = matchedSchedules
        ?.where(_isTimeOverlapping)
        .toList();
    final visibleSchedules = _showOnlyOverlappingSchedules
        ? overlappingSchedules
        : matchedSchedules;

    return PopScope(
      canPop: _editingScheduleId == null || !_isInlineEditing,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _editingScheduleId != null && _isInlineEditing) {
          _stopEditingSchedule();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('일정 등록')),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const AppSurfaceCard(
                    child: AppHeader(
                      title: '사장님 일정 등록',
                      subtitle: '직원, 날짜, 시간을 선택해 근무 일정을 빠르게 등록합니다.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '직원 선택',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        members.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, _) => Text('$error'),
                          data: (items) {
                            if (items.isEmpty) {
                              return const Text('일정을 등록할 활성 직원이 없습니다.');
                            }
                            return DropdownButtonFormField<int>(
                              initialValue: _selectedMemberId,
                              decoration: const InputDecoration(
                                labelText: '직원',
                              ),
                              items: items
                                  .where((item) => item.shopRole == 'STAFF')
                                  .map(
                                    (item) => DropdownMenuItem<int>(
                                      value: item.no,
                                      child: Text(item.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: _isSubmitting
                                  ? null
                                  : _onMemberChanged,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '날짜와 시간',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('근무 날짜'),
                          subtitle: Text(_formatDate(_workDate)),
                          trailing: const Icon(Icons.calendar_today_rounded),
                          onTap:
                              _isSubmitting ||
                                  (_editingRepeatGroupKey != null &&
                                      _editingScope != 'THIS_ONLY')
                              ? null
                              : _pickWorkDate,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('시작 시간'),
                                subtitle: Text(_formatTime(_startTime)),
                                trailing: const Icon(Icons.schedule_rounded),
                                onTap: _isSubmitting
                                    ? null
                                    : () => _pickTime(isStart: true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('종료 시간'),
                                subtitle: Text(_formatTime(_endTime)),
                                trailing: const Icon(Icons.schedule_rounded),
                                onTap: _isSubmitting
                                    ? null
                                    : () => _pickTime(isStart: false),
                              ),
                            ),
                          ],
                        ),
                        if (_editingScheduleId != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4D6),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    '기존 일정 1건을 수정 중입니다. 반복 등록은 사용할 수 없습니다.',
                                  ),
                                ),
                                TextButton(
                                  onPressed: _isSubmitting
                                      ? null
                                      : _stopEditingSchedule,
                                  child: const Text('수정 취소'),
                                ),
                              ],
                            ),
                          ),
                          if (_editingRepeatGroupKey != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              '반복 일정 수정 범위',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  const [
                                        ('THIS_ONLY', '이 일정만'),
                                        ('FOLLOWING', '이후 반복'),
                                        ('ALL', '전체 반복'),
                                      ]
                                      .map((scope) {
                                        return (scope.$1, scope.$2);
                                      })
                                      .map((scope) {
                                        final value = scope.$1;
                                        final label = scope.$2;
                                        return ChoiceChip(
                                          label: Text(label),
                                          selected: _editingScope == value,
                                          onSelected: _isSubmitting
                                              ? null
                                              : (_) {
                                                  setState(() {
                                                    _editingScope = value;
                                                  });
                                                },
                                        );
                                      })
                                      .toList(),
                            ),
                            if (_editingScope != 'THIS_ONLY') ...[
                              const SizedBox(height: 8),
                              Text(
                                '반복 일정 일괄 수정에서는 날짜는 유지되고 시간만 변경됩니다.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: const Color(0xFF6B787D)),
                              ),
                            ],
                          ],
                        ],
                        const SizedBox(height: 12),
                        Text(
                          '시간 프리셋',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        if (_selectedMemberId == null)
                          const Text('직원을 선택하면 기존 일정 기준 시간 프리셋을 보여줍니다.')
                        else if (monthlyPresetSchedules == null)
                          const SizedBox.shrink()
                        else
                          monthlyPresetSchedules.when(
                            loading: () =>
                                const LinearProgressIndicator(minHeight: 2),
                            error: (_, stackTrace) => _PresetChipWrap(
                              presets: _buildFallbackDurationPresets(),
                              isSubmitting: _isSubmitting,
                              startTime: _startTime,
                              endTime: _endTime,
                              onPresetSelected: (preset) {
                                setState(() {
                                  _startTime = preset.startTime;
                                  _endTime = preset.endTime;
                                });
                              },
                            ),
                            data: (items) {
                              final memberHistory = items
                                  .where((item) => item.status == 'SCHEDULED')
                                  .toList();
                              if (memberHistory.isNotEmpty) {
                                return _PresetChipWrap(
                                  presets: _buildSchedulePresets(memberHistory),
                                  isSubmitting: _isSubmitting,
                                  startTime: _startTime,
                                  endTime: _endTime,
                                  onPresetSelected: (preset) {
                                    setState(() {
                                      _startTime = preset.startTime;
                                      _endTime = preset.endTime;
                                    });
                                  },
                                );
                              }
                              return monthlyShopPresetSchedules.when(
                                loading: () =>
                                    const LinearProgressIndicator(minHeight: 2),
                                error: (_, stackTrace) => _PresetChipWrap(
                                  presets: _buildFallbackDurationPresets(),
                                  isSubmitting: _isSubmitting,
                                  startTime: _startTime,
                                  endTime: _endTime,
                                  onPresetSelected: (preset) {
                                    setState(() {
                                      _startTime = preset.startTime;
                                      _endTime = preset.endTime;
                                    });
                                  },
                                ),
                                data: (shopItems) {
                                  final shopHistory = shopItems
                                      .where(
                                        (item) => item.status == 'SCHEDULED',
                                      )
                                      .toList();
                                  final presets = shopHistory.isNotEmpty
                                      ? _buildSchedulePresets(shopHistory)
                                      : _buildFallbackDurationPresets();
                                  return _PresetChipWrap(
                                    presets: presets,
                                    isSubmitting: _isSubmitting,
                                    startTime: _startTime,
                                    endTime: _endTime,
                                    onPresetSelected: (preset) {
                                      setState(() {
                                        _startTime = preset.startTime;
                                        _endTime = preset.endTime;
                                      });
                                    },
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('매주 반복 등록'),
                          subtitle: const Text('같은 시간대를 여러 요일에 반복 배정합니다.'),
                          value: _repeatWeekly,
                          onChanged: _isSubmitting || _editingScheduleId != null
                              ? null
                              : _onRepeatWeeklyChanged,
                        ),
                        if (_repeatWeekly) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _weekdayOptions.map((day) {
                              final selected = _repeatDays.contains(day.value);
                              return FilterChip(
                                label: Text(day.label),
                                selected: selected,
                                onSelected: _isSubmitting
                                    ? null
                                    : (value) =>
                                          _onRepeatDayChanged(day.value, value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('반복 종료일'),
                            subtitle: Text(
                              _repeatUntil == null
                                  ? '선택해주세요'
                                  : _formatDate(_repeatUntil!),
                            ),
                            trailing: const Icon(Icons.event_repeat_rounded),
                            onTap: _isSubmitting ? null : _pickRepeatUntil,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _repeatWeekly ? '반복 범위 기존 일정' : '선택한 날짜 기존 일정',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('겹치는 일정만 보기'),
                          subtitle: const Text('현재 입력한 시간과 충돌하는 일정만 먼저 확인합니다.'),
                          value: _showOnlyOverlappingSchedules,
                          onChanged: _isSubmitting
                              ? null
                              : (value) {
                                  setState(() {
                                    _showOnlyOverlappingSchedules = value;
                                  });
                                },
                        ),
                        if (_selectedMemberId == null)
                          const Text('직원을 먼저 선택하면 기존 일정을 확인할 수 있습니다.'),
                        if (_selectedMemberId != null &&
                            selectedRangeSchedules != null)
                          selectedRangeSchedules.when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, _) => Text('$error'),
                            data: (_) {
                              final items =
                                  visibleSchedules ??
                                  const <ScheduleSummaryResponse>[];
                              if (items.isEmpty) {
                                return Text(
                                  _showOnlyOverlappingSchedules
                                      ? '현재 입력 시간과 겹치는 일정이 없습니다.'
                                      : _repeatWeekly
                                      ? '선택한 반복 범위에는 등록된 일정이 없습니다.'
                                      : '${_formatDate(_workDate)}에는 등록된 일정이 없습니다.',
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_repeatWeekly)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: OutlinedButton(
                                        onPressed:
                                            _isSubmitting || _isBulkCancelling
                                            ? null
                                            : () => _cancelSchedules(items),
                                        child: Text(
                                          _isBulkCancelling
                                              ? '취소 중...'
                                              : '반복 범위 일정 모두 취소',
                                        ),
                                      ),
                                    ),
                                  for (final item in items) ...[
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F6F1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (item.workDate != null)
                                                  Text(
                                                    _formatDate(item.workDate!),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: const Color(
                                                            0xFF6B787D,
                                                          ),
                                                        ),
                                                  ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _formatTimeRangeFromStrings(
                                                    item.startTime,
                                                    item.endTime,
                                                  ),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color:
                                                            _isTimeOverlapping(
                                                              item,
                                                            )
                                                            ? const Color(
                                                                0xFFC92A2A,
                                                              )
                                                            : null,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          OutlinedButton(
                                            onPressed:
                                                _isSubmitting ||
                                                    _isBulkCancelling ||
                                                    _editingScheduleId ==
                                                        item.no
                                                ? null
                                                : () => _startEditingSchedule(
                                                    item,
                                                  ),
                                            child: Text(
                                              _editingScheduleId == item.no
                                                  ? '수정 중'
                                                  : '수정',
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          OutlinedButton(
                                            onPressed:
                                                _isSubmitting ||
                                                    _isBulkCancelling ||
                                                    _cancellingScheduleId ==
                                                        item.no
                                                ? null
                                                : () => _cancelSchedule(item),
                                            child: Text(
                                              _cancellingScheduleId == item.no
                                                  ? '취소 중...'
                                                  : '일정 취소',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (item != items.last)
                                      const SizedBox(height: 10),
                                  ],
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppPrimaryButton(
                    onPressed: _isSubmitting ? null : _submit,
                    isLoading: _isSubmitting,
                    label: _editingScheduleId == null ? '일정 등록' : '일정 수정',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PresetChipWrap extends StatelessWidget {
  const _PresetChipWrap({
    required this.presets,
    required this.isSubmitting,
    required this.startTime,
    required this.endTime,
    required this.onPresetSelected,
  });

  final List<({String label, TimeOfDay startTime, TimeOfDay endTime})> presets;
  final bool isSubmitting;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final void Function(({String label, TimeOfDay startTime, TimeOfDay endTime}))
  onPresetSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((preset) {
        final isSelected =
            preset.startTime.hour == startTime.hour &&
            preset.startTime.minute == startTime.minute &&
            preset.endTime.hour == endTime.hour &&
            preset.endTime.minute == endTime.minute;
        return ChoiceChip(
          label: Text(preset.label),
          selected: isSelected,
          onSelected: isSubmitting ? null : (_) => onPresetSelected(preset),
        );
      }).toList(),
    );
  }
}
