#!/usr/bin/python
# coding:utf-8

from fabric import Connection
from invoke import task

# ptr_path='/mnt/hgfs/ptr'
# release_path='/mnt/hgfs/ServerRelease'
ptr_path='/home/ServerPTR'
release_path='/home/ServerRelease'
revert_cmd='svn revert -R -q ClashOfKingProject'
locale='export LC_CTYPE=en_US.UTF-8'
svnUp='svn up'
project='ClashOfKingProject'
trunk_path='http://svn.super-chameleon.com:8822/svn/hg/10.MVP-A/Source/trunk/Server/ClashOfKingProject'
divide=" && "



@task
def m(c,svn,r=False):
         with c.cd(ptr_path):
            mergesvn(c,svn)
         if r :
             with c.cd(release_path):
               mergesvn(c,svn)



def mergesvn(c,svn):
     c.run("{}&&{}".format(locale,revert_cmd))
     c.run("{}&&{}".format(locale,svnUp))
     with c.cd(project):
                for s in svn.split(" "):
                   n = int(s) - 1
                   c.run("{}&&svn merge -r {}:{} {}".format(locale,n,s,trunk_path))



@task
def r(c):
   print(ptr_path + "\n")
  # c.run("cd " + ptr_path + " && " +locale + " && " + revert_cmd)
   c.run (mul_param("cd "+ptr_path, locale,revert_cmd))
   print("------------------------------------ \n\nrevert ServerRelease\n")
   c.run("cd " + release_path + " && " +locale + " && " + revert_cmd)

@task
def diff(c,p=False,r=False):
     cmd1='svn diff'
     if p :
        print("ptr \n")
        with c.cd(ptr_path):
            c.run(mul_param(locale, cmd1))
        # c.run("cd /home/ServerPTR/ClashOfKingProject && export LC_CTYPE=en_US.UTF-8 && svn diff")
     if r :
        with c.cd(release_path):
            c.run(mul_param(locale, cmd1))


@task
def commit(c,mes,p=False,r=False):
    cmd1='svn commit -m ' + "'" + mes + "' *"
    if p :
        with c.cd(ptr_path):
            with c.cd(project):
               c.run(mul_param(locale, cmd1))
    if r :
        with c.cd(release_path):
           with c.cd(project):
               c.run(mul_param(locale, cmd1))

# @task
# def commit(c,mes):
#         cmd1='svn commit -m ' + "'" + mes + "'"
#         with c.cd("project/"):
#                 c.run(cmd1)


def mul_param(*args):
    str = ''
    for a in args :
        if str == '' :
            str = a
            continue
        str = str + divide + a
    return str

#@task
#def build(c):
#    print("Building!")

@task
def build(c, clean=False):
    if clean:
        print("Cleaning!")
    print("Building!")

@task
def hi(c, name):
    print("Hi {}!".format(name))


@task(help={'name': "Name of the person to say hi to."})
def hi(c, name, sex):
    """
    Say hi to someone.
    """
    print("Hi {}!, {}".format(name, sex))


@task
def build1(c):
    c.run("ls")

@task
def connect(c):
   c = Connection('192.168.231.131', port=22, user='root', connect_kwargs={'password':'123456'})
   c.run('ls')



@task
def svnup(c):
    with  c.cd("/home/me/project"):
     c.run("ls")
     c.run("svn up")

@task
def mmmm(c,line,p=False):
      for ll in line.split(" "):
         with c.cd("/home/me/project/mm"):
          c.run("svn up .")
          a= int(ll)-1
          b = "svn merge -r {}:{} svn://localhost/project".format(a,ll)
          print(b)
          if p :
             print("bbb")
          c.run(b)





@task
def clean(c, docs=False, bytecode=False, extra=''):
    patterns = ['build']
    if docs:
        patterns.append('docs/_build')
    if bytecode:
        patterns.append('**/*.pyc')
    if extra:
        patterns.append(extra)
    for pattern in patterns:
        c.run("rm -rf {}".format(pattern))
