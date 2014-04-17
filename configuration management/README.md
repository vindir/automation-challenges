Configuration Management
========================

## Considerations

The first thing that sticks out with this challenge is that we're using facter to get our replacement values.  In a situation
where puppet is in place, we should avoid pushing files unles it's via the puppet installation as much as possible. The
one stand-out scenario where we may want a custom script here would be a developer tool for pushing temporary files to VMs
using the machine facts.

Given a little more free time, I'd lean toward filling scenario two with a tool like [Fabric](http://www.fabfile.org) for handling the SSH connections
across machines and [Jinja2](http://jinja.pocoo.org/) as a template engine. I'd imagine we could probably pull this off in under 20-30 lines of source,
but this isn't being implemented since time is short and the puppet scenario is more important to demonstrate here.

For satisfying this challenge with [Puppet](http://puppetlabs.com/), we can turn to [puppet-playground](https://github.com/example42/puppet-playground) by
the team at Example42.  Puppet Playground means we can demonstrate this in a running form using multiple VMs with only 20 minutes or so of prep.

## Setting it Up

The first thing we do is head over to https://github.com/example42/puppet-playground and fork a copy to play with and branch 

```
git clone git@github.com:example42/puppet-playground.git
git checkout -b feature/automation-challenge
```

With our branch ready we can add/update a few basic puppet files and we're basically done.  First we'll add an erb template for
the widgetfile that matches the template outlined in template.file, then follow up with an init.pp that defines a file resource
using the widget template, and finally we update our Vagrantfile to set the facter value for our systems, limited in this case
to a single fact for all machines, but with a bit of Vagrantfile editing the playground could easily support different facts per
 machine.

```
# ./puppet_playground/modules/site/templates/widgetfile.erb
option 1234
speed 88mph
capacitor_type flux
widget_type <%= @widget %>
model delorean
avoid shopping_mall_parking_lots

# ./puppet_playground/manifests/init.pp
file { "/etc/widgetfile":
  path    => "/etc/widgetfile",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('site/widgetfile.erb')
}

# ./puppet_playground/Vagrantfile
      #...
      local.vm.provision :puppet do |puppet|
        #...
        puppet.facter = {
          "widget" => "SeriousyAwesome"
        }
      end
      #...
```

Once we have the files ready, we check the playground branch into our test fork and push it up to github. With the fork in place adding
the puppet playground demo into is as easy as adding a subtree to the automation challenge repo.

```
git remote add playground git@github.com:vindir/puppet-playground.git 
git fetch playground
git subtree add --prefix configuration\ management/puppet_playground feature/automation-challenge --squash
git subtree add --prefix configuration\ management/puppet_playground git@github.com:vindir/puppet-playground.git --squash
```


## Putting it Into Action

You need **[VirtualBox](https://www.virtualbox.org/)** , **[Vagrant](http://www.vagrantup.com/)** and **Git** installed on your system.

Then you can move into the playground directory.

    cd puppet-playground

Note: from this point all commands are relative to this path.

To use the playground, you also need **[Librarian Puppet](https://github.com/rodjek/librarian-puppet)** and the vagrant cachier plugin.  You
can install both as seen here:

    gem install librarian-puppet
    vagrant plugin install vagrant-cachier

Finally, we bring up our VMs and watch as Vagrant and the Puppet provisioner go to work.  Once this completes, the widgetfile is in place and
we're all done.

```
# The playground has a number of VMs ready to spin up. Let's take a look
vagrant status

# The images we *know* work are the CentOS images, so let's bring those up.
vagrant up /Centos[5-6]/
```

et voila!
