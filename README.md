# ExJira

A JIRA client library for Elixir using [erlang-oauth](https://github.com/tim/erlang-oauth) to call the [JIRA REST API](https://docs.atlassian.com/jira/REST/latest).

A non-trivial project to help me get started using Elixir - Currently WIP.


## Usage

### 1. Get the Jira access token
In order to access Jira API you need to generate an access-token that must be included on each request to the Jira API

This page shows how to authenticate clients against the Jira REST API using OAuth (1.0a). We’ll explain how OAuth works with Jira, and walk you through an example of how to use OAuth to authenticate an Elixir application (consumer) against the Jira (resource) REST API for a user (resource owner).
This process is base on the Java version from [Jira documentation](https://developer.atlassian.com/cloud/jira/platform/jira-rest-api-oauth-authentication).

#### Before you begin
To generate the access-token that needs to be provided in the application where you're going to access de Jira API you must clone this repo and perform some requests and configuration.

#### Step 1 - Configure your client application as an OAuth consumer
In Jira, OAuth consumers are represented by application links. Application links use OAuth with RSA-SHA1 signing for authentication. This means that a private key is used to sign requests, rather than the OAuth token secret/consumer secret. In the following steps, you’ll be generating an RSA public/private key pair, then creating a new application link in Jira that uses the key.

##### Generate an RSA public/private key pair
In your terminal, run the following openssl commands. You can do this anywhere in your file system.
```bash
$ openssl genrsa -out jira_elixir.pem 1024

```

![genrsa](/images/openssl1.png)

```bash
$ openssl req -newkey rsa:1024 -x509 -key jira_elixir.pem -out jira_elixir_publickey.cer -days 365
```

![req](/images/openssl2.png)

```bash
$ openssl pkcs8 -topk8 -nocrypt -in jira_elixir.pem  -out jira_elixir_privatekey.pcks8
```

![pkcs8](/images/openssl3.png)

```bash
$ openssl x509 -pubkey -noout -in jira_elixir_publickey.cer   > jira_elixir_public.pem
```
![x509](/images/openssl4.png)
Note that 4 files where created through the process.

This generates a 1024 bit private key, creates an X509 certificate, and extracts the private key (PKCS8 format) to the jira_elixir_privatekey.pcks8 file. It then extracts the public key from the certificate to the jira_elixir_public.pem file.

##### Configure the client app as a consumer in Jira, using application links

1. In Jira, navigate to **Settings -> Applications > Application links (Integrations section)**.

2. In the field, enter any URL, e.g. http://my-jira-elixir.com/ and click **Create new link**.
![New application link](/images/jira1.png)

You’ll get a warning that **No response was received from the URL you entered**. Ignore it and click Continue.
![Application link warning](/images/jira2.png)

3. On the first screen of the Link applications dialog, enter anything you want in the fields. However, make sure you tick the *Create incoming link checkbox*.
![Application link config](/images/jira3.png)

*Note, in this example, it doesn’t matter what you enter for the client application details (URL, name, type, etc). This is because we only want to retrieve data from Jira, therefore we only need to set up a one-way (incoming) link from the client to Jira.*

4. The next screen of the Link applications dialog is where you enter the consumer details for the sample client. Important to take note of the following values: *Consumer key*, *Consumer name*, *Public key*. Copy the public key from the jira_elixir_publickey.pem file you generated previously and paste it into this field.
Keep in mind that the **Consumer key** value that you tipe it's going to be needed for the configuration process. In this case `ElixirJiraClientConsumerKey`
![Application config config](/images/jira4.png)
![Application config config](/images/openssl5.png)
5.Click **Continue**. You should end up with an application link that looks like like this:
![Application config config](/images/jira5.png)

That’s it! You’ve now configured the sample client as an OAuth consumer in Jira.

#### 2. Setup

Add the following to the deps section in `mix.exs`.
```elixir
defp deps do
  [
    {:exjira, "~> 0.0.1"},
    {:oauth, github: "tim/erlang-oauth"}
  ]
end
```

#### 2. Setup Init OAuth parameters

Use `ExJira.configure` to setup the JIRA OAuth parameters. See the Configuration section below for further details.

There are three ways to configure ExJira:

#### Using config.exs

In `config/config.exs` add the following:

```elixir
use Mix.Config

 config :ex_jira, oauth: [
   site: "https://your-site.atlassian.net",
   private_key_file: "jira_elixir.pem",
   consumer_key: "ElixirJiraClientConsumerKey"
 ]
```

#### Across the application at runtime

```elixir
ExJira.configure([consumer_key: "", ...])
```

#### For the current process at runtime

```elixir
ExJira.configure(:process, [consumer_key: "", ...])
```

#### 3. Genrate JIRA access token
In order to access Jira API resources it's needed to provide access tokens, the following steps show how to accomplish this.

* After adding dependencies to the project run `$ mix deps.get` to download dependencies to your project.
* Know run `$ mix run -e 'ExJira.CLI.process()'` to start the process. Then you should see an url that you need to navigate in your prouser to grant app authorization to the resources.

![Jira authorization](/images/setup1.png)

In the authorization process just click the `Allow` button
![Jira authorization](/images/setup2.png)

Know you will se an `Access Approved` screen.
![Jira authorization](/images/setup3.png)

If you have any errror you will have a response like the following:
![Jira Error Response 1](/images/error-response1.png)
![Jira Error Response 2](/images/error-response2.png)

When this is done, you'll get all the credentials need to access Jira API.
![Jira credentials](/images/setup4.png)
