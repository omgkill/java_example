#!/usr/bin/python
# coding:utf-8

from fabric import Connection
from invoke import task

# ptr_path='/mnt/hgfs/ptr'
# release_path='/mnt/hgfs/ServerRelease'
ptr_path = '/disk4/ServerPTR'
release_path = '/disk4/ServerRelease'
commit_release_path = '/disk4/ServerRelease/ClashOfKingProject/cok-game'
revert_cmd = 'svn revert -R -q ClashOfKingProject'
locale = 'export LC_CTYPE=en_US.UTF-8'
svnUp = 'svn up'
project = 'ClashOfKingProject'
trunk_path = 'http://svn.super-chameleon.com:8822/svn/hg/10.MVP-A/Source/trunk/Server/ClashOfKingProject'
divide = " && "
win_ptr = '/mnt/hgfs/ptr/ClashOfKingProject'
win_release = '/mnt/hgfs/ServerRelease/ClashOfKingProject'


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
def mv(c,p=False,r=False):
    if p :
        c.run("rm -rf " + win_ptr + "/*")
        c.run("cp -R -f " + ptr_path + "/" + project + "/*  " + win_ptr)
    if r :
        c.run("cp -R -f " + release_path + "/" + project + "/*  " + win_release)


@task(help={'name': "svn revert"})
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


@task(help={'name': "svn commit p:ptr,r:release"})
def commit(c,mes,p=False,r=False):
    cmd1='svn commit -m ' +"'" + mes + "' * "
    cmd2='cd '+ project
    if p :
        with c.cd(ptr_path):
            c.run(mul_param(cmd2, locale, cmd1))
    if r:
        with c.cd(commit_release_path):
            c.run(mul_param(locale, cmd1))


@task
def deploy(c, s):
    """
    deploy project, s : 几服
    """
    print (s)
    deploy_or_refresh(c, s, 'false')


@task
def refresh(c, s):
    """
    deploy project, s : 几服
    """
    print (s)
    deploy_or_refresh(c, s, 'true')


def deploy_or_refresh(c, s, is_refresh):
    ip = ""
    pw = '1q2w3e4r5t'
    path = "deploy_aoeii.sh"
    if is_refresh == 'true':
        path = "refresh_xml"
    if s == '11':
        c.run("/root/bw_hg/deploy_aoeii.sh")
        if is_refresh == 'true':
            c.run("/root/bw_hg/refresh_xml.sh")
        return 0
    if s == '1':
        ip = "10.0.3.187"
        path = "restart.sh"
        if is_refresh == 'true':
            path = "refresh_xml"
    if s == '8':
        ip = "10.0.3.191"
    if s == '997':
        ip = "10.0.3.189"
    if s == '998':
        ip = "10.0.3.189"
    print ("----" + s)
    c = Connection(ip, port=22, user='root', connect_kwargs={'password': pw})
    c.run("/root/bw_hg/" + path)


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

# @task
# def redis_get(c, line):
#      c = Connection('hg-26.super-chameleon.com', port=22, user='root', connect_kwargs={'password':'H2KhsbH2slqU1'})
#      for ll in line.split(";"):
#         str = "redis-cli -h 10.81.81.66 -p 6379 exists UI_" + ll
#         print(ll + "-")
#         c.run(str)



@task
def redis_get(c, line):
     dd = ''
     for ll in line.split(";"):
        str = "redis-cli  exists UI_" + ll
        d = c.run(str, hide=True)
        ret = d.stdout.splitlines()[-1].strip()
       # print(d.stdout.splitlines()) 这是一个数组
        if ret == '1': # '!' 必须有引号，才行
            dd = ll
     print(dd)


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

@task
def move_redis(c) :
    with open('m.txt', encoding='utf-8') as file_obj:
        while True:
            line = file_obj.readline()
            if not line:
                break
            str = line.rstrip().lstrip()
            c.run("redis-cli move "+ str + " 2")
