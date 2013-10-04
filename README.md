# Kinvey on NoFlo <br/>[![Build Status](https://secure.travis-ci.org/kenhkan/noflo-kinvey.png?branch=master)](http://travis-ci.org/kenhkan/noflo-kinvey) [![Dependency Status](https://david-dm.org/kenhkan/noflo-kinvey.png)](https://david-dm.org/kenhkan/noflo-kinvey) [![NPM version](https://badge.fury.io/js/noflo-kinvey.png)](http://badge.fury.io/js/noflo-kinvey) [![Stories in Ready](https://badge.waffle.io/kenhkan/noflo-kinvey.png)](http://waffle.io/kenhkan/noflo-kinvey)

Use [Kinvey](http://devcenter.kinvey.com/) as your backend? Want to use NoFlo
too? Here's the package that you need! This is a simple wrapper around [Kinvey
NPM library](https://npmjs.org/package/kinvey).


## Installation

`npm install --save noflo-kinvey`

## Usage

* [kinvey/Kinvey](#Kinvey)
* [kinvey/DataStoreFind](#DataStoreFind)
* [kinvey/DataStoreSave](#DataStoreSave)

Listed in-ports in bold are required and out-ports in bold always produce IPs.

DataStore operations in Kinvey allows the use of promises within the call itself, like:

    var promise = Kinvey.DataStore.save('users', event, {
      success: function(response) { ... }
    });

The last (third) argument is part of the 'options' parameter, or the 'OPTIONS'
port in `noflo-kinvey`. In NoFlo, it does not make sense to pass the functions
in the options parameter, so please avoid doing so. Instead, the component
should output to its 'OUT' port a promise, which can then be piped to a
`promise/Then` for further instructions.


### Kinvey

Set up your Kinvey account

#### In-Ports

* *KEY*: The app key
* *SECRET*: The app secret

#### Out-Ports

* *OUT*: A copy of a Kinvey instance


### DataStoreFind

Wrapper of `Kinvey.DataStore.find(3)`

#### In-Ports

* *IN*: A Kinvey.Query object from `kinvey/Query`
* *COLLECTION*: The name of the collection
* *KINVEY*: An instance of Kinvey
* OPTIONS: Ditto

#### Out-Ports

* *OUT*: A promise
* ERROR: error arises when the incoming is not a Kinvey.Query object


### DataStoreSave

Wrapper of `Kinvey.DataStore.save(3)`

#### In-Ports

* *IN*: The document to save
* *COLLECTION*: The name of the collection
* *KINVEY*: An instance of Kinvey
* OPTIONS: Ditto

#### Out-Ports

* *OUT*: A promise


### Query

Wrapper around `Kinvey.Query`

Each parameter port (EQUALTO, etc) accepts a series of IPs. Each IP is an array
corresponding to the Kinvey documentation. IPs in the same connection are
applied together. A new connection to a port resets that particular parameter.

#### In-Ports

* *IN*: Pass in anything and a `Kinvey.Query` object would be created
* OPTIONS: Ditto
* EQUALTO: calls `equalTo(field, value)`


### UserLogin

Wrapper around `Kinvey.User.login(3)`

#### In-Ports

* *USER*: Username or user data
* PASSWORD: The password
* OPTIONS: Ditto

#### Out-Ports

* *OUT*: A promise
