// Mocks generated by Mockito 5.4.0 from annotations
// in luna/test/calendar_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:collection' as _i5;
import 'dart:ui' as _i9;

import 'package:device_calendar/src/device_calendar.dart' as _i3;
import 'package:device_calendar/src/models/calendar.dart' as _i6;
import 'package:device_calendar/src/models/event.dart' as _i7;
import 'package:device_calendar/src/models/result.dart' as _i2;
import 'package:device_calendar/src/models/retrieve_events_params.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeResult_0<T> extends _i1.SmartFake implements _i2.Result<T> {
  _FakeResult_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [DeviceCalendarPlugin].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeviceCalendarPlugin extends _i1.Mock
    implements _i3.DeviceCalendarPlugin {
  MockDeviceCalendarPlugin() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Result<bool>> requestPermissions() => (super.noSuchMethod(
        Invocation.method(
          #requestPermissions,
          [],
        ),
        returnValue: _i4.Future<_i2.Result<bool>>.value(_FakeResult_0<bool>(
          this,
          Invocation.method(
            #requestPermissions,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Result<bool>>);
  @override
  _i4.Future<_i2.Result<bool>> hasPermissions() => (super.noSuchMethod(
        Invocation.method(
          #hasPermissions,
          [],
        ),
        returnValue: _i4.Future<_i2.Result<bool>>.value(_FakeResult_0<bool>(
          this,
          Invocation.method(
            #hasPermissions,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Result<bool>>);
  @override
  _i4.Future<_i2.Result<_i5.UnmodifiableListView<_i6.Calendar>>>
      retrieveCalendars() => (super.noSuchMethod(
            Invocation.method(
              #retrieveCalendars,
              [],
            ),
            returnValue: _i4.Future<
                    _i2.Result<_i5.UnmodifiableListView<_i6.Calendar>>>.value(
                _FakeResult_0<_i5.UnmodifiableListView<_i6.Calendar>>(
              this,
              Invocation.method(
                #retrieveCalendars,
                [],
              ),
            )),
          ) as _i4.Future<_i2.Result<_i5.UnmodifiableListView<_i6.Calendar>>>);
  @override
  _i4.Future<_i2.Result<_i5.UnmodifiableListView<_i7.Event>>> retrieveEvents(
    String? calendarId,
    _i8.RetrieveEventsParams? retrieveEventsParams,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #retrieveEvents,
          [
            calendarId,
            retrieveEventsParams,
          ],
        ),
        returnValue:
            _i4.Future<_i2.Result<_i5.UnmodifiableListView<_i7.Event>>>.value(
                _FakeResult_0<_i5.UnmodifiableListView<_i7.Event>>(
          this,
          Invocation.method(
            #retrieveEvents,
            [
              calendarId,
              retrieveEventsParams,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.UnmodifiableListView<_i7.Event>>>);
  @override
  _i4.Future<_i2.Result<bool>> deleteEvent(
    String? calendarId,
    String? eventId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteEvent,
          [
            calendarId,
            eventId,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<bool>>.value(_FakeResult_0<bool>(
          this,
          Invocation.method(
            #deleteEvent,
            [
              calendarId,
              eventId,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<bool>>);
  @override
  _i4.Future<_i2.Result<bool>> deleteEventInstance(
    String? calendarId,
    String? eventId,
    int? startDate,
    int? endDate,
    bool? deleteFollowingInstances,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteEventInstance,
          [
            calendarId,
            eventId,
            startDate,
            endDate,
            deleteFollowingInstances,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<bool>>.value(_FakeResult_0<bool>(
          this,
          Invocation.method(
            #deleteEventInstance,
            [
              calendarId,
              eventId,
              startDate,
              endDate,
              deleteFollowingInstances,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<bool>>);
  @override
  _i4.Future<_i2.Result<String>?> createOrUpdateEvent(_i7.Event? event) =>
      (super.noSuchMethod(
        Invocation.method(
          #createOrUpdateEvent,
          [event],
        ),
        returnValue: _i4.Future<_i2.Result<String>?>.value(),
      ) as _i4.Future<_i2.Result<String>?>);
  @override
  _i4.Future<_i2.Result<String>> createCalendar(
    String? calendarName, {
    _i9.Color? calendarColor,
    String? localAccountName,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createCalendar,
          [calendarName],
          {
            #calendarColor: calendarColor,
            #localAccountName: localAccountName,
          },
        ),
        returnValue: _i4.Future<_i2.Result<String>>.value(_FakeResult_0<String>(
          this,
          Invocation.method(
            #createCalendar,
            [calendarName],
            {
              #calendarColor: calendarColor,
              #localAccountName: localAccountName,
            },
          ),
        )),
      ) as _i4.Future<_i2.Result<String>>);
  @override
  _i4.Future<_i2.Result<bool>> deleteCalendar(String? calendarId) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteCalendar,
          [calendarId],
        ),
        returnValue: _i4.Future<_i2.Result<bool>>.value(_FakeResult_0<bool>(
          this,
          Invocation.method(
            #deleteCalendar,
            [calendarId],
          ),
        )),
      ) as _i4.Future<_i2.Result<bool>>);
  @override
  _i4.Future<_i2.Result<void>> showiOSEventModal(String? eventId) =>
      (super.noSuchMethod(
        Invocation.method(
          #showiOSEventModal,
          [eventId],
        ),
        returnValue: _i4.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #showiOSEventModal,
            [eventId],
          ),
        )),
      ) as _i4.Future<_i2.Result<void>>);
}