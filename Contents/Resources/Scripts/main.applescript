property name : "XHandler"
property version : "1.3"

(*!@title XHandler Reference
* Version : 1.3
* Author : Tetsuro KURITA ((<tkurita@mac.com>))
*)

(*!@group Constructor Method *)

(*!@abstruct
<!-- begin locale ja -->
ハンドラの名前と引数の数を指定して、XHandler のインスタンスを生成します。
<!-- begin locale en -->
Make a new XHandler instance specifing the name of the handler and the number of arguments
<!-- end locale -->

@description
<!-- begin locale ja -->
XHandler のインスタンスは指定したハンドラを実行する為のスクリプトオブジェクトです。
実行するハンドラは位置パラメータを持つことができます。
ラベルパラメータを持ったハンドラは扱えません。
<!-- begin locale en -->
A XHandler instance is a script object to call a specified handler. 
The handler to be called can have positional parameters. Handlers which have labal parameters is not supported.
<!-- end locale -->

@param handler_name (text) : 
<!-- begin locale ja -->ハンドラの名前
<!-- begin locale en -->a text to specify a handler
<!-- end locale -->
@param nargs (integer) : 
<!-- begin locale ja -->呼び出すハンドラがとる引数の数
<!-- begin locale en -->number of arguments of a handler to be called.
<!-- end locale -->
@result script object
*)
on make_with(handler_name, nargs)
	
	set args1 to ""
	repeat with ith from 1 to nargs
		set args1 to args1 & ", arg" & ith
	end repeat
	
	if nargs > 0 then
		set args2 to text 2 thru -1 of args1
	else
		set args2 to args1
	end if
	
	(*!@group Instance Methods of a Handler Object *)
	
	(*!@syntax do(target_object, variable_arguments)
	@abstruct
	<!-- begin locale ja -->
	指定されたハンドラをターゲットオブジェクト（引数 target_object に渡されたスクリプトオブジェクト） で実行します。
	<!-- begin locale en -->
	Call the specified handelr of a passed script object (target object) with a passed arument.
	<!-- end locale -->
	@param target_object (script object) : 
	<!-- begin locale ja -->実行するハンドラを持っているスクリプトオブジェクト
	<!-- begin locale en -->a script object of which handler is called.
	<!-- end locale -->
	@param variable_arguments : 
	<!-- begin locale ja -->ハンドラに渡すパラメータ。arg1, arg2, ... というように、
			make_with の　nargs で指定した数だけ与える必要があります。
	<!-- begin locale en -->arguments passed to the handler.
			Pass arguments of numbers specfied with nargs in make_with as arg1, arg2, ...
	<!-- end locale -->
	@result　anything :
	<!-- begin locale ja -->呼び出したハンドラからの返り値
	<!-- begin locale en --> a returned value from the handler.<!-- end locale -->
	*)
	
	(*!@syntax call_to(target_object, variable_arguments)
	@abstruct
	<!-- begin locale ja -->
	指定されたハンドラをターゲットオブジェクト（引数 target_object に渡されたスクリプトオブジェクト） で実行します。
	
	もし、ターゲットオブジェクトが指定したハンドラを持っていない場合は、ハンドラ successor() の実行を試みます。
	successor() の返り値が得られれば、その返り値に対して call_to を適用します。
	この仕組みを利用して、chain of responder や method forwading を行うことができます。
	<!-- begin locale en -->
	Call the specified handelr of a passed script object (target object) with a passed arument.
	
	If target object can not respond to the handler and have a handler of successor(), 
	call_to is excuted for the returned object from successor(). 
	This feature can be used for the chain of responder or method forwarding.
	<!-- end locale -->
	@param target_object (script object) : 
	<!-- begin locale ja -->ハンドラが呼び出されるスクリプトオブジェクト
	<!-- begin locale en -->a target object of which handler is called.
	<!-- end locale -->
	@param variable_arguments : 
	<!-- begin locale ja -->ハンドラに渡すパラメータ。arg1, arg2, ... というように、
	make_with の　nargs で指定した数だけ与える必要があります。
	<!-- begin locale en -->arguments passed to the handler.
	Pass arguments of numbers specfied with nargs in make_with as arg1, arg2, ...
	<!-- end locale -->
	@result　anything :
	<!-- begin locale ja -->呼び出したハンドラからの返り値
	<!-- begin locale en --> a returned value from the handler.<!-- end locale -->
	*)
	
	(*!@syntax responded_by(target_object)
	@abstruct
	<!-- begin locale ja -->
	ハンドラがターゲットオブジェクトが指定されたハンドラを実行できるか調べます。
	
	<!-- begin locale en -->
	Test whether the passed script object can respond to the handler.
	<!-- end locale -->
	@param target_object (script object) : 
	<!-- begin locale ja -->スクリプトオブジェクト
	<!-- begin locale en -->a target object
	<!-- end locale -->
	@result　boolean : 
	<!-- begin locale ja -->target_object が指定したハンドラを実行できるなら true
	<!-- begin locale en -->true when the passed script object can respond to the handler.<!-- end locale -->
	*)
	set a_xhandler to run script "
script XHandler
on do(target_object" & args1 & ")
	return target_object's " & handler_name & "(" & args2 & ")
end do

on call_to(target_object" & args1 & ")
	try
		return do(target_object" & args1 & ")
	end try
	
	try
		set a_successor to target_object's successor()
	on error
		return
	end try
	
	try
		return call_to(a_successor" & args1 & ")
	end try
	
end call_to

on responded_by(target_object)
	try
		return target_object's " & handler_name & "'s class is handler
	on error
		return false
	end
end
end script
return XHandler"
	
	return a_xhandler
end make_with

on run
	--debug()
	try
		show helpbook (path to me) with recovering InfoPlist
	on error msg number errno
		display alert (msg & return & errno)
	end try
end run

on debug()
end debug

