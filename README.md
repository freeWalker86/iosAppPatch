iosAppPatch
===========

Use NSBundle to implement dynamic add "path" to release app.    
"patch" is a code snippet in the bundle , this technology explain [`here`](https://github.com/freeWalker86/iosPlugin).
Then, i use Objective-C runtime swizzle to implement a hook method stub in stub app, support dynamic hook method which read from  bundle info list.
So, it's mean that you can fixed a bug in the release app by dynamic download a bundle from server and install it.


===========

FWStubApp
-----------
It works as a released stub app, has hook stub code that support dynamic add patch to it.

HookStub features:   

* dynamic hook methods which read from bundle info list.
* support class or instance method.
* support variable argument type and argument numbers.
* support bundle patch callBack, call original method.
* support get variable return type.


FWHotPatch
-----------
It works as a dependent patch which you want to dynamic add it to release app to fixed bug. 

Features:		

* FWHotPatchEntry as patch entry class, and FWHotPatchEntryProtocol declara the patch entry method.
* NSObject+FWIvarAccess category support get instance's data members which have not write @property.


The MIT License
---------------
Wax is Copyright (C) 2014 freeWalker86 See the file LICENSE for information of licensing and distribution.

