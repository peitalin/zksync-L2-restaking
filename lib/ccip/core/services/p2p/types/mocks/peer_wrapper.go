// Code generated by mockery v2.43.2. DO NOT EDIT.

package mocks

import (
	context "context"

	types "github.com/smartcontractkit/chainlink/v2/core/services/p2p/types"
	mock "github.com/stretchr/testify/mock"
)

// PeerWrapper is an autogenerated mock type for the PeerWrapper type
type PeerWrapper struct {
	mock.Mock
}

type PeerWrapper_Expecter struct {
	mock *mock.Mock
}

func (_m *PeerWrapper) EXPECT() *PeerWrapper_Expecter {
	return &PeerWrapper_Expecter{mock: &_m.Mock}
}

// Close provides a mock function with given fields:
func (_m *PeerWrapper) Close() error {
	ret := _m.Called()

	if len(ret) == 0 {
		panic("no return value specified for Close")
	}

	var r0 error
	if rf, ok := ret.Get(0).(func() error); ok {
		r0 = rf()
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// PeerWrapper_Close_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Close'
type PeerWrapper_Close_Call struct {
	*mock.Call
}

// Close is a helper method to define mock.On call
func (_e *PeerWrapper_Expecter) Close() *PeerWrapper_Close_Call {
	return &PeerWrapper_Close_Call{Call: _e.mock.On("Close")}
}

func (_c *PeerWrapper_Close_Call) Run(run func()) *PeerWrapper_Close_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run()
	})
	return _c
}

func (_c *PeerWrapper_Close_Call) Return(_a0 error) *PeerWrapper_Close_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *PeerWrapper_Close_Call) RunAndReturn(run func() error) *PeerWrapper_Close_Call {
	_c.Call.Return(run)
	return _c
}

// GetPeer provides a mock function with given fields:
func (_m *PeerWrapper) GetPeer() types.Peer {
	ret := _m.Called()

	if len(ret) == 0 {
		panic("no return value specified for GetPeer")
	}

	var r0 types.Peer
	if rf, ok := ret.Get(0).(func() types.Peer); ok {
		r0 = rf()
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).(types.Peer)
		}
	}

	return r0
}

// PeerWrapper_GetPeer_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'GetPeer'
type PeerWrapper_GetPeer_Call struct {
	*mock.Call
}

// GetPeer is a helper method to define mock.On call
func (_e *PeerWrapper_Expecter) GetPeer() *PeerWrapper_GetPeer_Call {
	return &PeerWrapper_GetPeer_Call{Call: _e.mock.On("GetPeer")}
}

func (_c *PeerWrapper_GetPeer_Call) Run(run func()) *PeerWrapper_GetPeer_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run()
	})
	return _c
}

func (_c *PeerWrapper_GetPeer_Call) Return(_a0 types.Peer) *PeerWrapper_GetPeer_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *PeerWrapper_GetPeer_Call) RunAndReturn(run func() types.Peer) *PeerWrapper_GetPeer_Call {
	_c.Call.Return(run)
	return _c
}

// HealthReport provides a mock function with given fields:
func (_m *PeerWrapper) HealthReport() map[string]error {
	ret := _m.Called()

	if len(ret) == 0 {
		panic("no return value specified for HealthReport")
	}

	var r0 map[string]error
	if rf, ok := ret.Get(0).(func() map[string]error); ok {
		r0 = rf()
	} else {
		if ret.Get(0) != nil {
			r0 = ret.Get(0).(map[string]error)
		}
	}

	return r0
}

// PeerWrapper_HealthReport_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'HealthReport'
type PeerWrapper_HealthReport_Call struct {
	*mock.Call
}

// HealthReport is a helper method to define mock.On call
func (_e *PeerWrapper_Expecter) HealthReport() *PeerWrapper_HealthReport_Call {
	return &PeerWrapper_HealthReport_Call{Call: _e.mock.On("HealthReport")}
}

func (_c *PeerWrapper_HealthReport_Call) Run(run func()) *PeerWrapper_HealthReport_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run()
	})
	return _c
}

func (_c *PeerWrapper_HealthReport_Call) Return(_a0 map[string]error) *PeerWrapper_HealthReport_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *PeerWrapper_HealthReport_Call) RunAndReturn(run func() map[string]error) *PeerWrapper_HealthReport_Call {
	_c.Call.Return(run)
	return _c
}

// Name provides a mock function with given fields:
func (_m *PeerWrapper) Name() string {
	ret := _m.Called()

	if len(ret) == 0 {
		panic("no return value specified for Name")
	}

	var r0 string
	if rf, ok := ret.Get(0).(func() string); ok {
		r0 = rf()
	} else {
		r0 = ret.Get(0).(string)
	}

	return r0
}

// PeerWrapper_Name_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Name'
type PeerWrapper_Name_Call struct {
	*mock.Call
}

// Name is a helper method to define mock.On call
func (_e *PeerWrapper_Expecter) Name() *PeerWrapper_Name_Call {
	return &PeerWrapper_Name_Call{Call: _e.mock.On("Name")}
}

func (_c *PeerWrapper_Name_Call) Run(run func()) *PeerWrapper_Name_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run()
	})
	return _c
}

func (_c *PeerWrapper_Name_Call) Return(_a0 string) *PeerWrapper_Name_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *PeerWrapper_Name_Call) RunAndReturn(run func() string) *PeerWrapper_Name_Call {
	_c.Call.Return(run)
	return _c
}

// Ready provides a mock function with given fields:
func (_m *PeerWrapper) Ready() error {
	ret := _m.Called()

	if len(ret) == 0 {
		panic("no return value specified for Ready")
	}

	var r0 error
	if rf, ok := ret.Get(0).(func() error); ok {
		r0 = rf()
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// PeerWrapper_Ready_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Ready'
type PeerWrapper_Ready_Call struct {
	*mock.Call
}

// Ready is a helper method to define mock.On call
func (_e *PeerWrapper_Expecter) Ready() *PeerWrapper_Ready_Call {
	return &PeerWrapper_Ready_Call{Call: _e.mock.On("Ready")}
}

func (_c *PeerWrapper_Ready_Call) Run(run func()) *PeerWrapper_Ready_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run()
	})
	return _c
}

func (_c *PeerWrapper_Ready_Call) Return(_a0 error) *PeerWrapper_Ready_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *PeerWrapper_Ready_Call) RunAndReturn(run func() error) *PeerWrapper_Ready_Call {
	_c.Call.Return(run)
	return _c
}

// Start provides a mock function with given fields: _a0
func (_m *PeerWrapper) Start(_a0 context.Context) error {
	ret := _m.Called(_a0)

	if len(ret) == 0 {
		panic("no return value specified for Start")
	}

	var r0 error
	if rf, ok := ret.Get(0).(func(context.Context) error); ok {
		r0 = rf(_a0)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}

// PeerWrapper_Start_Call is a *mock.Call that shadows Run/Return methods with type explicit version for method 'Start'
type PeerWrapper_Start_Call struct {
	*mock.Call
}

// Start is a helper method to define mock.On call
//   - _a0 context.Context
func (_e *PeerWrapper_Expecter) Start(_a0 interface{}) *PeerWrapper_Start_Call {
	return &PeerWrapper_Start_Call{Call: _e.mock.On("Start", _a0)}
}

func (_c *PeerWrapper_Start_Call) Run(run func(_a0 context.Context)) *PeerWrapper_Start_Call {
	_c.Call.Run(func(args mock.Arguments) {
		run(args[0].(context.Context))
	})
	return _c
}

func (_c *PeerWrapper_Start_Call) Return(_a0 error) *PeerWrapper_Start_Call {
	_c.Call.Return(_a0)
	return _c
}

func (_c *PeerWrapper_Start_Call) RunAndReturn(run func(context.Context) error) *PeerWrapper_Start_Call {
	_c.Call.Return(run)
	return _c
}

// NewPeerWrapper creates a new instance of PeerWrapper. It also registers a testing interface on the mock and a cleanup function to assert the mocks expectations.
// The first argument is typically a *testing.T value.
func NewPeerWrapper(t interface {
	mock.TestingT
	Cleanup(func())
}) *PeerWrapper {
	mock := &PeerWrapper{}
	mock.Mock.Test(t)

	t.Cleanup(func() { mock.AssertExpectations(t) })

	return mock
}
