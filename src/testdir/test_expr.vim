" Tests for expressions.

func Test_equal()
  let base = {}
  func base.method()
    return 1
  endfunc
  func base.other() dict
    return 1
  endfunc
  let instance = copy(base)
  call assert_true(base.method == instance.method)
  call assert_true([base.method] == [instance.method])
  call assert_true(base.other == instance.other)
  call assert_true([base.other] == [instance.other])

  call assert_false(base.method == base.other)
  call assert_false([base.method] == [base.other])
  call assert_false(base.method == instance.other)
  call assert_false([base.method] == [instance.other])

  call assert_fails('echo base.method > instance.method')
endfunc

func Test_version()
  call assert_true(has('patch-7.4.001'))
  call assert_true(has('patch-7.4.01'))
  call assert_true(has('patch-7.4.1'))
  call assert_true(has('patch-6.9.999'))
  call assert_true(has('patch-7.1.999'))
  call assert_true(has('patch-7.4.123'))

  call assert_false(has('patch-7'))
  call assert_false(has('patch-7.4'))
  call assert_false(has('patch-7.4.'))
  call assert_false(has('patch-9.1.0'))
  call assert_false(has('patch-9.9.1'))
endfunc

func Test_dict()
  let d = {'': 'empty', 'a': 'a', 0: 'zero'}
  call assert_equal('empty', d[''])
  call assert_equal('a', d['a'])
  call assert_equal('zero', d[0])
  call assert_true(has_key(d, ''))
  call assert_true(has_key(d, 'a'))

  let d[''] = 'none'
  let d['a'] = 'aaa'
  call assert_equal('none', d[''])
  call assert_equal('aaa', d['a'])
endfunc

func Test_strgetchar()
  call assert_equal(char2nr('a'), strgetchar('axb', 0))
  call assert_equal(char2nr('x'), strgetchar('axb', 1))
  call assert_equal(char2nr('b'), strgetchar('axb', 2))

  call assert_equal(-1, strgetchar('axb', -1))
  call assert_equal(-1, strgetchar('axb', 3))
  call assert_equal(-1, strgetchar('', 0))
endfunc

func Test_strcharpart()
  call assert_equal('a', strcharpart('axb', 0, 1))
  call assert_equal('x', strcharpart('axb', 1, 1))
  call assert_equal('b', strcharpart('axb', 2, 1))
  call assert_equal('xb', strcharpart('axb', 1))

  call assert_equal('', strcharpart('axb', 1, 0))
  call assert_equal('', strcharpart('axb', 1, -1))
  call assert_equal('', strcharpart('axb', -1, 1))
  call assert_equal('', strcharpart('axb', -2, 2))

  call assert_equal('a', strcharpart('axb', -1, 2))
endfunc

func Test_getreg_empty_list()
  call assert_equal('', getreg('x'))
  call assert_equal([], getreg('x', 1, 1))
  let x = getreg('x', 1, 1)
  let y = x
  call add(x, 'foo')
  call assert_equal(['foo'], y)
endfunc

func Test_loop_over_null_list()
  let null_list = test_null_list()
  for i in null_list
    call assert_true(0, 'should not get here')
  endfor
endfunc

func Test_compare_null_dict()
  call assert_fails('let x = test_null_dict()[10]')
  call assert_equal({}, {})
  call assert_equal(test_null_dict(), test_null_dict())
  call assert_notequal({}, test_null_dict())
endfunc

func Test_set_reg_null_list()
  call setreg('x', test_null_list())
endfunc

func Test_special_char()
  " The failure is only visible using valgrind.
  call assert_fails('echo "\<C-">')
endfunc
