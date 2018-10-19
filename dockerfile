<!DOCTYPE html>
<html lang="en">

<!-- Head tag -->
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="google-site-verification" content="xBT4GhYoi5qRD5tr338pgPM5OWHHIDR6mNg1a3euekI" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Linux运维笔记">
    <meta name="keyword"  content="sunday,sundayhk,sundayle,sunday博客,Linxu,运维">
    <link rel="shortcut icon" href="/img/favicon.ico">

    <title>
        
          Docker(二)：Dockerfile 使用详情 - Sunday博客 | Sunday Blog
        
    </title>

    <link rel="canonical" href="http://www.sundayle.com/dockerfile">

    <!-- Bootstrap Core CSS -->
    <link rel="stylesheet" href="/css/bootstrap.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="/css/hux-blog.min.css">

    <!-- Pygments Highlight CSS -->
    <link rel="stylesheet" href="/css/highlight.css">

    <!-- Custom Fonts -->
    <!-- <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css"> -->
    <!-- Hux change font-awesome CDN to qiniu -->
    <link href="https://cdn.staticfile.org/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">


    <!-- Hux Delete, sad but pending in China
    <link href='http://fonts.googleapis.com/css?family=Lora:400,700,400italic,700italic' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/
    css'>
    -->


    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- ga & ba script hoook -->
    <script></script>
</head>


<!-- hack iOS CSS :active style -->
<body ontouchstart="">

    <!-- Navigation -->
<nav class="navbar navbar-default navbar-custom navbar-fixed-top">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header page-scroll">
            <button type="button" class="navbar-toggle">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/">Sunday</a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <!-- Known Issue, found by Hux:
            <nav>'s height woule be hold on by its content.
            so, when navbar scale out, the <nav> will cover tags.
            also mask any touch event of tags, unfortunately.
        -->
        <div id="huxblog_navbar">
            <div class="navbar-collapse">
                <ul class="nav navbar-nav navbar-right">
                    <li>
                        <a href="/">Home</a>
                    </li>

                    

                        
                    

                        
                        <li>
                            <a href="/about/">About</a>
                        </li>
                        
                    

                        
                        <li>
                            <a href="/archives/">Archives</a>
                        </li>
                        
                    

                        
                        <li>
                            <a href="/tags/">Tags</a>
                        </li>
                        
                    
                    
                </ul>
            </div>
        </div>
        <!-- /.navbar-collapse -->
    </div>
    <!-- /.container -->
</nav>
<script>
    // Drop Bootstarp low-performance Navbar
    // Use customize navbar with high-quality material design animation
    // in high-perf jank-free CSS3 implementation
    var $body   = document.body;
    var $toggle = document.querySelector('.navbar-toggle');
    var $navbar = document.querySelector('#huxblog_navbar');
    var $collapse = document.querySelector('.navbar-collapse');

    $toggle.addEventListener('click', handleMagic)
    function handleMagic(e){
        if ($navbar.className.indexOf('in') > 0) {
        // CLOSE
            $navbar.className = " ";
            // wait until animation end.
            setTimeout(function(){
                // prevent frequently toggle
                if($navbar.className.indexOf('in') < 0) {
                    $collapse.style.height = "0px"
                }
            },400)
        }else{
        // OPEN
            $collapse.style.height = "auto"
            $navbar.className += " in";
        }
    }
</script>


    <!-- Main Content -->
    
<!-- Image to hack wechat -->
<!-- <img src="http://www.sundayle.com/img/icon_wechat.png" width="0" height="0"> -->
<!-- <img src="{{ site.baseurl }}/{% if page.header-img %}{{ page.header-img }}{% else %}{{ site.header-img }}{% endif %}" width="0" height="0"> -->

<!-- Post Header -->
<style type="text/css">
    header.intro-header{
        background-image: url('/img/home-bg.jpg')
    }
</style>
<header class="intro-header" >
    <div class="container">
        <div class="row">
            <div class="col-lg-8 col-lg-offset-2 col-md-10 col-md-offset-1">
                <div class="post-heading">
                    <div class="tags">
                        
                          <a class="tag" href="/tags/#docker" title="docker">docker</a>
                        
                    </div>
                    <h1>Docker(二)：Dockerfile 使用详情</h1>
                    <h2 class="subheading"></h2>
                    <span class="meta">
                        Posted by Sunday on
                        2018-10-16
                    </span>
                </div>
            </div>
        </div>
    </div>
</header>

<!-- Post Content -->
<article>
    <div class="container">
        <div class="row">

    <!-- Post Container -->
            <div class="
                col-lg-8 col-lg-offset-2
                col-md-10 col-md-offset-1
                post-container">

                <h1 id="Dockerfile-概念"><a href="#Dockerfile-概念" class="headerlink" title="Dockerfile 概念"></a>Dockerfile 概念</h1><hr>
<p>Dockerfile 是一个文本文件，其内包含了一条条的指令(Instruction)，每一条指令构建一层，因此每一条指令的内容，就是描述该层应当如何构建。有了 Dockerfile，当我们需要定制自己额外的需求时，只需在 Dockerfile 上添加或者修改指令，重新生成 image 即可，省去了敲命令的麻烦。</p>
<h1 id="Dockerfile-文件格式"><a href="#Dockerfile-文件格式" class="headerlink" title="Dockerfile 文件格式"></a>Dockerfile 文件格式</h1><hr>
<figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br><span class="line">5</span><br><span class="line">6</span><br><span class="line">7</span><br><span class="line">8</span><br><span class="line">9</span><br><span class="line">10</span><br><span class="line">11</span><br><span class="line">12</span><br><span class="line">13</span><br><span class="line">14</span><br><span class="line">15</span><br><span class="line">16</span><br><span class="line">17</span><br><span class="line">18</span><br></pre></td><td class="code"><pre><span class="line"><span class="comment"># This dockerfile uses the ubuntu image</span></span><br><span class="line"><span class="comment"># VERSION 2 - EDITION 1</span></span><br><span class="line"><span class="comment"># Author: docker_user</span></span><br><span class="line"><span class="comment"># Command format: Instruction [arguments / command] ..</span></span><br><span class="line"> </span><br><span class="line"><span class="comment"># 1 第一行必须指定 基础镜像信息</span></span><br><span class="line"><span class="keyword">FROM</span> ubuntu</span><br><span class="line"> </span><br><span class="line"><span class="comment"># 2 维护者信息</span></span><br><span class="line"><span class="keyword">MAINTAINER</span> docker_user docker_user@email.com</span><br><span class="line"> </span><br><span class="line"><span class="comment"># 3 镜像操作指令</span></span><br><span class="line"><span class="keyword">RUN</span><span class="bash"> sed -i <span class="string">'s#archive.ubuntu.com#mirrors.aliyun.com#g'</span> /etc/apt/sources.list </span></span><br><span class="line"><span class="bash">RUN apt-get update &amp;&amp; apt-get install -y nginx</span></span><br><span class="line"><span class="bash">RUN <span class="built_in">echo</span> <span class="string">"\ndaemon off;"</span> &gt;&gt; /etc/nginx/nginx.conf</span></span><br><span class="line"><span class="bash"> </span></span><br><span class="line"><span class="bash"><span class="comment"># 4 容器启动执行指令</span></span></span><br><span class="line"><span class="bash">CMD /usr/sbin/nginx</span></span><br></pre></td></tr></table></figure>
<h1 id="简单示例"><a href="#简单示例" class="headerlink" title="简单示例"></a>简单示例</h1><figure class="highlight vim"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br></pre></td><td class="code"><pre><span class="line"><span class="built_in">mkdir</span> mynginx</span><br><span class="line"><span class="keyword">cd</span> mynginx</span><br><span class="line"><span class="keyword">vi</span> Dockerfile</span><br></pre></td></tr></table></figure>
<p><strong>构建 Dockerfile 文件内容</strong><br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">FROM</span> nginx</span><br><span class="line"><span class="keyword">RUN</span><span class="bash"> <span class="built_in">echo</span> <span class="string">'&lt;h1&gt;Hello, Docker!&lt;/h1&gt;'</span> &gt; /usr/share/nginx/html/index.html</span></span><br></pre></td></tr></table></figure></p>
<p><strong>构建及打标签</strong><br><figure class="highlight armasm"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line"><span class="symbol">docker</span> <span class="keyword">build </span>-t nginx:<span class="built_in">v1</span> .</span><br></pre></td></tr></table></figure></p>
<p>命令最后有一个<code>.</code>表示当前目录</p>
<p><strong>查看构建镜像</strong><br><figure class="highlight plain"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br></pre></td><td class="code"><pre><span class="line">docker images</span><br><span class="line">REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE</span><br><span class="line">nginx                           v1                  8c92471de2cc        6 minutes ago       108.6 MB</span><br></pre></td></tr></table></figure></p>
<p><strong>运行容器</strong><br><figure class="highlight applescript"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line">docker <span class="built_in">run</span>  <span class="comment">--name docker_nginx_v1 -d -p 80:80 nginx:v1</span></span><br></pre></td></tr></table></figure></p>
<p>启动容器，命名为docker_nginx_v1，映射80 端口<br><figure class="highlight groovy"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line">curl <span class="string">http:</span><span class="comment">//192.168.0.54/</span></span><br><span class="line">Hello,Docker!</span><br></pre></td></tr></table></figure></p>
<p>这样一个简单使用 Dockerfile 构建镜像，运行容器的示例就完成了！</p>
<p><strong> 修改容器内容 </strong><br><figure class="highlight elixir"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br></pre></td><td class="code"><pre><span class="line">docker exec -it docker_nginx_v1 bash</span><br><span class="line">root<span class="variable">@3729b97e8226</span><span class="symbol">:/</span><span class="comment"># echo '&lt;h1&gt;Hello, Docker neo!&lt;/h1&gt;' &gt; /usr/share/nginx/html/index.html</span></span><br><span class="line">root<span class="variable">@3729b97e8226</span><span class="symbol">:/</span><span class="comment"># exit</span></span><br></pre></td></tr></table></figure></p>
<figure class="highlight groovy"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line">curl <span class="string">http:</span><span class="comment">//192.168.0.54/</span></span><br><span class="line">Hello,Docker neo!</span><br></pre></td></tr></table></figure>
<p>修改了容器的文件，也就是改动了容器的存储层，可以通过 docker diff 命令看到具体的改动。<br><figure class="highlight clean"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line">docker diff docker_nginx_v1 </span><br><span class="line">...</span><br></pre></td></tr></table></figure></p>
<h1 id="Dockerfile-指令详解"><a href="#Dockerfile-指令详解" class="headerlink" title="Dockerfile 指令详解"></a>Dockerfile 指令详解</h1><h2 id="1-FROM-指定基础镜像"><a href="#1-FROM-指定基础镜像" class="headerlink" title="1 FROM 指定基础镜像"></a>1 FROM 指定基础镜像</h2><p>FROM语法格式为：<br><figure class="highlight elixir"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br><span class="line">5</span><br></pre></td><td class="code"><pre><span class="line">FROM &lt;image&gt;</span><br><span class="line">或</span><br><span class="line">FROM &lt;image&gt;<span class="symbol">:&lt;tag&gt;</span></span><br><span class="line">或</span><br><span class="line">FROM &lt;image&gt;<span class="symbol">:&lt;digest&gt;</span></span><br></pre></td></tr></table></figure></p>
<p>通过 FROM 指定的镜像，可以是任何有效的基础镜像。FROM 有以下限制：</p>
<ul>
<li>FROM 必须 是 Dockerfile 中第一条非注释命令</li>
<li>在一个 Dockerfile 文件中创建多个镜像时，FROM 可以多次出现。只需在每个新命令 FROM 之前，记录提交上次的镜像 ID。</li>
<li>tag 或 digest 是可选的，如果不使用这两个值时，会使用 latest 版本的基础镜像</li>
</ul>
<h2 id="2-RUN-执行命令"><a href="#2-RUN-执行命令" class="headerlink" title="2 RUN 执行命令"></a>2 RUN 执行命令</h2><p>在镜像的构建过程中执行特定的命令，并生成一个中间镜像。格式:<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br></pre></td><td class="code"><pre><span class="line"><span class="comment">#shell格式</span></span><br><span class="line"><span class="keyword">RUN</span><span class="bash"> &lt;<span class="built_in">command</span>&gt;</span></span><br><span class="line"><span class="bash"><span class="comment">#exec格式</span></span></span><br><span class="line"><span class="bash">RUN [<span class="string">"executable"</span>, <span class="string">"param1"</span>, <span class="string">"param2"</span>]</span></span><br></pre></td></tr></table></figure></p>
<ul>
<li>RUN 命令将在当前 image 中执行任意合法命令并提交执行结果。命令执行提交后，就会自动执行 Dockerfile 中的下一个指令。</li>
<li>层级 RUN 指令和生成提交是符合 Docker 核心理念的做法。它允许像版本控制那样，在任意一个点，对 image 镜像进行定制化构建。</li>
<li>RUN 指令创建的中间镜像会被缓存，并会在下次构建中使用。如果不想使用这些缓存镜像，可以在构建时指定 –no-cache 参数，如：<code>docker build --no-cache</code>。</li>
</ul>
<h2 id="3-COPY-复制文件"><a href="#3-COPY-复制文件" class="headerlink" title="3 COPY 复制文件"></a>3 COPY 复制文件</h2><p>格式：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">COPY</span><span class="bash"> &lt;源路径&gt;... &lt;目标路径&gt;</span></span><br><span class="line"><span class="bash">COPY [<span class="string">"&lt;源路径1&gt;"</span>,... <span class="string">"&lt;目标路径&gt;"</span>]</span></span><br></pre></td></tr></table></figure></p>
<p>和 RUN 指令一样，也有两种格式，一种类似于命令行，一种类似于函数调用。COPY 指令将从构建上下文目录中<code>&lt;源路径&gt;</code>的文件/目录复制到新的一层的镜像内的<code>&lt;目标路径&gt;</code>位置。比如：<br><figure class="highlight gradle"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">COPY</span> <span class="keyword">package</span>.json <span class="regexp">/usr/</span>src<span class="regexp">/app/</span></span><br></pre></td></tr></table></figure></p>
<p><code>&lt;源路径&gt;</code>可以是多个，甚至可以是通配符，其通配符规则要满足 Go 的 filepath.Match 规则，如：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">COPY</span><span class="bash"> hom* /mydir/</span></span><br><span class="line"><span class="bash">COPY hom?.txt /mydir/</span></span><br></pre></td></tr></table></figure></p>
<p><code>&lt;目标路径&gt;</code>可以是容器内的绝对路径，也可以是相对于工作目录的相对路径（工作目录可以用 WORKDIR 指令来指定）。目标路径不需要事先创建，如果目录不存在会在复制文件前先行创建缺失目录。</p>
<p>此外，还需要注意一点，使用 COPY 指令，源文件的各种元数据都会保留。比如读、写、执行权限、文件变更时间等。这个特性对于镜像定制很有用。特别是构建相关文件都在使用 Git 进行管理的时候。</p>
<h2 id="4-ADD-更高级的复制文件"><a href="#4-ADD-更高级的复制文件" class="headerlink" title="4 ADD 更高级的复制文件"></a>4 ADD 更高级的复制文件</h2><p>ADD 指令和 COPY 的格式和性质基本一致。但是在 COPY 基础上增加了一些功能。比如<code>&lt;源路径&gt;</code>可以是一个 URL，这种情况下，Docker 引擎会试图去下载这个链接的文件放到<code>&lt;目标路径&gt;</code>去。</p>
<p>在构建镜像时，复制上下文中的文件到镜像内，格式：<br><figure class="highlight routeros"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line"><span class="builtin-name">ADD</span> &lt;源路径&gt;<span class="built_in">..</span>. &lt;目标路径&gt;</span><br><span class="line"><span class="builtin-name">ADD</span> [<span class="string">"&lt;源路径&gt;"</span>,<span class="built_in">..</span>. <span class="string">"&lt;目标路径&gt;"</span>]</span><br></pre></td></tr></table></figure></p>
<p>注意：如果 docker 发现文件内容被改变，则接下来的指令都不会再使用缓存。关于复制文件时需要处理的/，基本跟正常的 copy 一致</p>
<h2 id="5-ENV-设置环境变量"><a href="#5-ENV-设置环境变量" class="headerlink" title="5 ENV 设置环境变量"></a>5 ENV 设置环境变量</h2><p>格式有两种：<br><figure class="highlight xml"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line">ENV <span class="tag">&lt;<span class="name">key</span>&gt;</span> <span class="tag">&lt;<span class="name">value</span>&gt;</span></span><br><span class="line">ENV <span class="tag">&lt;<span class="name">key1</span>&gt;</span>=<span class="tag">&lt;<span class="name">value1</span>&gt;</span> <span class="tag">&lt;<span class="name">key2</span>&gt;</span>=<span class="tag">&lt;<span class="name">value2</span>&gt;</span>...</span><br></pre></td></tr></table></figure></p>
<p>这个指令很简单，就是设置环境变量而已，无论是后面的其它指令，如 RUN，还是运行时的应用，都可以直接使用这里定义的环境变量。<br><figure class="highlight routeros"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line">ENV <span class="attribute">VERSION</span>=1.0 <span class="attribute">DEBUG</span>=on \</span><br><span class="line">    <span class="attribute">NAME</span>=<span class="string">"Happy Feet"</span></span><br></pre></td></tr></table></figure></p>
<p>这个例子中演示了如何换行，以及对含有空格的值用双引号括起来的办法，这和 Shell 下的行为是一致的。</p>
<h2 id="6-EXPOSE"><a href="#6-EXPOSE" class="headerlink" title="6 EXPOSE"></a>6 EXPOSE</h2><p>为构建的镜像设置监听端口，使容器在运行时监听。格式：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">EXPOSE</span> &lt;port&gt; [&lt;port&gt;...]</span><br><span class="line"><span class="keyword">EXPOSE</span> 指令并不会让容器监听 host 的端口，如果需要，需要在 docker <span class="keyword">run</span><span class="bash"> 时使用 -p、-P 参数来发布容器端口到 host 的某个端口上。</span></span><br></pre></td></tr></table></figure></p>
<h2 id="7-VOLUME-定义匿名卷"><a href="#7-VOLUME-定义匿名卷" class="headerlink" title="7 VOLUME 定义匿名卷"></a>7 VOLUME 定义匿名卷</h2><p>VOLUME用于创建挂载点，即向基于所构建镜像创始的容器添加卷：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">VOLUME</span><span class="bash"> [<span class="string">"/data"</span>]</span></span><br></pre></td></tr></table></figure></p>
<p>一个卷可以存在于一个或多个容器的指定目录，该目录可以绕过联合文件系统，并具有以下功能：</p>
<ul>
<li>卷可以容器间共享和重用</li>
<li>容器并不一定要和其它容器共享卷</li>
<li>修改卷后会立即生效</li>
<li>对卷的修改不会对镜像产生影响</li>
<li>卷会一直存在，直到没有任何容器在使用它</li>
</ul>
<p>VOLUME 让我们可以将源代码、数据或其它内容添加到镜像中，而又不并提交到镜像中，并使我们可以多个容器间共享这些内容。</p>
<h2 id="8-WORKDIR-指定工作目录"><a href="#8-WORKDIR-指定工作目录" class="headerlink" title="8 WORKDIR 指定工作目录"></a>8 WORKDIR 指定工作目录</h2><p>WORKDIR用于在容器内设置一个工作目录：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">WORKDIR</span><span class="bash"> /path/to/workdir</span></span><br></pre></td></tr></table></figure></p>
<p>通过WORKDIR设置工作目录后，Dockerfile 中其后的命令 RUN、CMD、ENTRYPOINT、ADD、COPY 等命令都会在该目录下执行。 如，使用WORKDIR设置工作目录：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">WORKDIR</span><span class="bash"> /a</span></span><br><span class="line"><span class="bash">WORKDIR b</span></span><br><span class="line"><span class="bash">WORKDIR c</span></span><br><span class="line"><span class="bash">RUN <span class="built_in">pwd</span></span></span><br></pre></td></tr></table></figure></p>
<p>在以上示例中，pwd 最终将会在 /a/b/c 目录中执行。在使用 docker run 运行容器时，可以通过-w参数覆盖构建时所设置的工作目录。</p>
<h2 id="9-USER-指定当前用户"><a href="#9-USER-指定当前用户" class="headerlink" title="9 USER 指定当前用户"></a>9 USER 指定当前用户</h2><p>USER 用于指定运行镜像所使用的用户：<br><figure class="highlight crmsh"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">USER</span> <span class="title">daemon</span></span><br></pre></td></tr></table></figure></p>
<p>使用USER指定用户时，可以使用用户名、UID 或 GID，或是两者的组合。以下都是合法的指定试：<br><figure class="highlight routeros"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br><span class="line">5</span><br><span class="line">6</span><br></pre></td><td class="code"><pre><span class="line">USER user</span><br><span class="line">USER user:group</span><br><span class="line">USER uid</span><br><span class="line">USER uid:gid</span><br><span class="line">USER user:gid</span><br><span class="line">USER uid:group</span><br></pre></td></tr></table></figure></p>
<p>使用USER指定用户后，Dockerfile 中其后的命令 RUN、CMD、ENTRYPOINT 都将使用该用户。镜像构建完成后，通过 docker run 运行容器时，可以通过 -u 参数来覆盖所指定的用户。</p>
<h2 id="10-CMD"><a href="#10-CMD" class="headerlink" title="10 CMD"></a>10 CMD</h2><p>CMD用于指定在容器启动时所要执行的命令。CMD 有以下三种格式：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">CMD</span><span class="bash"> [<span class="string">"executable"</span>,<span class="string">"param1"</span>,<span class="string">"param2"</span>]</span></span><br><span class="line"><span class="bash">CMD [<span class="string">"param1"</span>,<span class="string">"param2"</span>]</span></span><br><span class="line"><span class="bash">CMD <span class="built_in">command</span> param1 param2</span></span><br></pre></td></tr></table></figure></p>
<p>省略可执行文件的 exec 格式，这种写法使 CMD 中的参数当做 ENTRYPOINT 的默认参数，此时 ENTRYPOINT 也应该是 exec 格式，具体与 ENTRYPOINT 的组合使用，参考 ENTRYPOINT。</p>
<p>注意: 与 RUN 指令的区别：RUN 在构建的时候执行，并生成一个新的镜像，CMD 在容器运行的时候执行，在构建时不进行任何操作。</p>
<h2 id="11-ENTRYPOINT"><a href="#11-ENTRYPOINT" class="headerlink" title="11 ENTRYPOINT"></a>11 ENTRYPOINT</h2><p>ENTRYPOINT 用于给容器配置一个可执行程序。也就是说，每次使用镜像创建容器时，通过 ENTRYPOINT 指定的程序都会被设置为默认程序。ENTRYPOINT 有以下两种形式：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">ENTRYPOINT</span><span class="bash"> [<span class="string">"executable"</span>, <span class="string">"param1"</span>, <span class="string">"param2"</span>]</span></span><br><span class="line"><span class="bash">ENTRYPOINT <span class="built_in">command</span> param1 param2</span></span><br></pre></td></tr></table></figure></p>
<p>ENTRYPOINT 与 CMD 非常类似，不同的是通过<code>docker run</code>执行的命令不会覆盖 ENTRYPOINT，而<code>docker run</code>命令中指定的任何参数，都会被当做参数再次传递给 ENTRYPOINT。Dockerfile 中只允许有一个 ENTRYPOINT 命令，多指定时会覆盖前面的设置，而只执行最后的 ENTRYPOINT 指令。</p>
<p><code>docker run</code>运行容器时指定的参数都会被传递给 ENTRYPOINT ，且会覆盖 CMD 命令指定的参数。如，执行<code>docker run &lt;image&gt; -d</code>时，-d 参数将被传递给入口点。</p>
<p>也可以通过<code>docker run --entrypoint</code>重写 ENTRYPOINT 入口点。如：可以像下面这样指定一个容器执行程序：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">ENTRYPOINT</span><span class="bash"> [<span class="string">"/usr/bin/nginx"</span>]</span></span><br></pre></td></tr></table></figure></p>
<p>完整构建代码：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br><span class="line">5</span><br><span class="line">6</span><br><span class="line">7</span><br><span class="line">8</span><br><span class="line">9</span><br></pre></td><td class="code"><pre><span class="line"><span class="comment"># Version: 0.0.3</span></span><br><span class="line"><span class="keyword">FROM</span> ubuntu:<span class="number">16.04</span></span><br><span class="line"><span class="keyword">MAINTAINER</span> 何民三 <span class="string">"cn.liuht@gmail.com"</span></span><br><span class="line"><span class="keyword">RUN</span><span class="bash"> apt-get update</span></span><br><span class="line"><span class="bash">RUN apt-get install -y nginx</span></span><br><span class="line"><span class="bash">RUN <span class="built_in">echo</span> <span class="string">'Hello World, 我是个容器'</span> \ </span></span><br><span class="line"><span class="bash">   &gt; /var/www/html/index.html</span></span><br><span class="line"><span class="bash">ENTRYPOINT [<span class="string">"/usr/sbin/nginx"</span>]</span></span><br><span class="line"><span class="bash">EXPOSE 80</span></span><br></pre></td></tr></table></figure></p>
<p>使用docker build构建镜像，并将镜像指定为 itbilu/test：<br><figure class="highlight armasm"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line"><span class="symbol">docker</span> <span class="keyword">build </span>-t=<span class="string">"itbilu/test"</span> .</span><br></pre></td></tr></table></figure></p>
<p>构建完成后，使用itbilu/test启动一个容器：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line">docker <span class="keyword">run</span><span class="bash"> -i -t  itbilu/<span class="built_in">test</span> -g <span class="string">"daemon off;"</span></span></span><br></pre></td></tr></table></figure></p>
<p>在运行容器时，我们使用了 -g “daemon off;”，这个参数将会被传递给 ENTRYPOINT，最终在容器中执行的命令为 /usr/sbin/nginx -g “daemon off;”。</p>
<h2 id="12-LABEL"><a href="#12-LABEL" class="headerlink" title="12 LABEL"></a>12 LABEL</h2><p>LABEL用于为镜像添加元数据，元数以键值对的形式指定：<br><figure class="highlight xml"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line">LABEL <span class="tag">&lt;<span class="name">key</span>&gt;</span>=<span class="tag">&lt;<span class="name">value</span>&gt;</span> <span class="tag">&lt;<span class="name">key</span>&gt;</span>=<span class="tag">&lt;<span class="name">value</span>&gt;</span> <span class="tag">&lt;<span class="name">key</span>&gt;</span>=<span class="tag">&lt;<span class="name">value</span>&gt;</span> ...</span><br></pre></td></tr></table></figure></p>
<p>使用LABEL指定元数据时，一条LABEL指定可以指定一或多条元数据，指定多条元数据时不同元数据之间通过空格分隔。推荐将所有的元数据通过一条LABEL指令指定，以免生成过多的中间镜像。 如，通过LABEL指定一些元数据：<br><figure class="highlight routeros"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line">LABEL <span class="attribute">version</span>=<span class="string">"1.0"</span> <span class="attribute">description</span>=<span class="string">"这是一个Web服务器"</span> <span class="attribute">by</span>=<span class="string">"IT笔录"</span></span><br></pre></td></tr></table></figure></p>
<p>指定后可以通过docker inspect查看：<br><figure class="highlight stata"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br><span class="line">5</span><br><span class="line">6</span><br></pre></td><td class="code"><pre><span class="line">docker <span class="keyword">inspect</span> itbilu/<span class="keyword">test</span></span><br><span class="line"><span class="string">"Labels"</span>: &#123;</span><br><span class="line">    <span class="string">"version"</span>: <span class="string">"1.0"</span>,</span><br><span class="line">    <span class="string">"description"</span>: <span class="string">"这是一个Web服务器"</span>,</span><br><span class="line">    <span class="string">"by"</span>: <span class="string">"IT笔录"</span></span><br><span class="line">&#125;,</span><br></pre></td></tr></table></figure></p>
<h2 id="13-ARG"><a href="#13-ARG" class="headerlink" title="13 ARG"></a>13 ARG</h2><p>ARG用于指定传递给构建运行时的变量：<br><figure class="highlight fortran"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line">ARG &lt;<span class="keyword">name</span>&gt;[=&lt;<span class="keyword">default</span> <span class="keyword">value</span>&gt;]</span><br></pre></td></tr></table></figure></p>
<p>如，通过ARG指定两个变量：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">ARG</span> site</span><br><span class="line"><span class="keyword">ARG</span> build_user=IT笔录</span><br></pre></td></tr></table></figure></p>
<p>以上我们指定了 site 和 build_user 两个变量，其中 build_user 指定了默认值。在使用 docker build 构建镜像时，可以通过 <code>--build-arg &lt;varname&gt;=&lt;value&gt;</code>参数来指定或重设置这些变量的值。<br><figure class="highlight armasm"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line"><span class="symbol">docker</span> <span class="keyword">build </span>--<span class="keyword">build-arg </span>site<span class="symbol">=itiblu</span>.com -t <span class="keyword">itbilu/test </span>.</span><br></pre></td></tr></table></figure></p>
<p>这样我们构建了 itbilu/test 镜像，其中site会被设置为 itbilu.com，由于没有指定 build_user，其值将是默认值 IT 笔录。</p>
<h2 id="14-ONBUILD"><a href="#14-ONBUILD" class="headerlink" title="14 ONBUILD"></a>14 ONBUILD</h2><p>ONBUILD用于设置镜像触发器：<br><figure class="highlight accesslog"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line">ONBUILD <span class="string">[INSTRUCTION]</span></span><br></pre></td></tr></table></figure></p>
<p>当所构建的镜像被用做其它镜像的基础镜像，该镜像中的触发器将会被钥触发。 如，当镜像被使用时，可能需要做一些处理：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br></pre></td><td class="code"><pre><span class="line">[...]</span><br><span class="line"><span class="keyword">ONBUILD</span> <span class="keyword">ADD</span><span class="bash"> . /app/src</span></span><br><span class="line"><span class="bash">ONBUILD RUN /usr/<span class="built_in">local</span>/bin/python-build --dir /app/src</span></span><br><span class="line"><span class="bash">[...]</span></span><br></pre></td></tr></table></figure></p>
<h2 id="15-STOPSIGNAL"><a href="#15-STOPSIGNAL" class="headerlink" title="15 STOPSIGNAL"></a>15 STOPSIGNAL</h2><p>STOPSIGNAL用于设置停止容器所要发送的系统调用信号：<br><figure class="highlight qml"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line">STOPSIGNAL <span class="keyword">signal</span><span class="string"></span></span><br></pre></td></tr></table></figure></p>
<p>所使用的信号必须是内核系统调用表中的合法的值，如：SIGKILL。</p>
<h2 id="16-SHELL"><a href="#16-SHELL" class="headerlink" title="16 SHELL"></a>16 SHELL</h2><p>SHELL用于设置执行命令（shell式）所使用的的默认 shell 类型：<br><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">SHELL</span><span class="bash"> [<span class="string">"executable"</span>, <span class="string">"parameters"</span>]</span></span><br></pre></td></tr></table></figure></p>
<p>SHELL在Windows环境下比较有用，Windows 下通常会有 cmd 和 powershell 两种 shell，可能还会有 sh。这时就可以通过 SHELL 来指定所使用的 shell 类型：<br><figure class="highlight routeros"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br><span class="line">5</span><br><span class="line">6</span><br><span class="line">7</span><br><span class="line">8</span><br><span class="line">9</span><br><span class="line">10</span><br><span class="line">11</span><br><span class="line">12</span><br><span class="line">13</span><br><span class="line">14</span><br><span class="line">15</span><br></pre></td><td class="code"><pre><span class="line"><span class="keyword">FROM</span> microsoft/windowsservercore</span><br><span class="line"></span><br><span class="line"><span class="comment"># Executed as cmd /S /C echo default</span></span><br><span class="line"><span class="builtin-name">RUN</span> echo default</span><br><span class="line"></span><br><span class="line"><span class="comment"># Executed as cmd /S /C powershell -command Write-Host default</span></span><br><span class="line"><span class="builtin-name">RUN</span> powershell -command Write-Host default</span><br><span class="line"></span><br><span class="line"><span class="comment"># Executed as powershell -command Write-Host hello</span></span><br><span class="line">SHELL [<span class="string">"powershell"</span>, <span class="string">"-command"</span>]</span><br><span class="line"><span class="builtin-name">RUN</span> Write-Host hello</span><br><span class="line"></span><br><span class="line"><span class="comment"># Executed as cmd /S /C echo hello</span></span><br><span class="line">SHELL [<span class="string">"cmd"</span>, <span class="string">"/S"</span><span class="string">", "</span>/C<span class="string">"]</span></span><br><span class="line"><span class="string">RUN echo hello</span></span><br></pre></td></tr></table></figure></p>
<h1 id="Dockerfile-使用经验"><a href="#Dockerfile-使用经验" class="headerlink" title="Dockerfile 使用经验"></a>Dockerfile 使用经验</h1><hr>
<h2 id="构建Nginx运行环境"><a href="#构建Nginx运行环境" class="headerlink" title="构建Nginx运行环境"></a>构建Nginx运行环境</h2><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br><span class="line">5</span><br><span class="line">6</span><br><span class="line">7</span><br><span class="line">8</span><br><span class="line">9</span><br><span class="line">10</span><br><span class="line">11</span><br><span class="line">12</span><br><span class="line">13</span><br><span class="line">14</span><br><span class="line">15</span><br><span class="line">16</span><br><span class="line">17</span><br><span class="line">18</span><br><span class="line">19</span><br><span class="line">20</span><br><span class="line">21</span><br><span class="line">22</span><br><span class="line">23</span><br><span class="line">24</span><br><span class="line">25</span><br><span class="line">26</span><br><span class="line">27</span><br><span class="line">28</span><br><span class="line">29</span><br><span class="line">30</span><br><span class="line">31</span><br><span class="line">32</span><br><span class="line">33</span><br><span class="line">34</span><br><span class="line">35</span><br><span class="line">36</span><br><span class="line">37</span><br><span class="line">38</span><br><span class="line">39</span><br><span class="line">40</span><br><span class="line">41</span><br><span class="line">42</span><br></pre></td><td class="code"><pre><span class="line"><span class="comment"># 指定基础镜像</span></span><br><span class="line"><span class="keyword">FROM</span> sameersbn/ubuntu:<span class="number">14.04</span>.<span class="number">20161014</span></span><br><span class="line"></span><br><span class="line"><span class="comment"># 维护者信息</span></span><br><span class="line"><span class="keyword">MAINTAINER</span> sameer@damagehead.com</span><br><span class="line"></span><br><span class="line"><span class="comment"># 设置环境</span></span><br><span class="line"><span class="keyword">ENV</span> RTMP_VERSION=<span class="number">1.1</span>.<span class="number">10</span> \</span><br><span class="line">    NPS_VERSION=<span class="number">1.11</span>.<span class="number">33.4</span> \</span><br><span class="line">    LIBAV_VERSION=<span class="number">11.8</span> \</span><br><span class="line">    NGINX_VERSION=<span class="number">1.10</span>.<span class="number">1</span> \</span><br><span class="line">    NGINX_USER=www-data \</span><br><span class="line">    NGINX_SITECONF_DIR=/etc/nginx/sites-enabled \</span><br><span class="line">    NGINX_LOG_DIR=/var/log/nginx \</span><br><span class="line">    NGINX_TEMP_DIR=/var/lib/nginx \</span><br><span class="line">    NGINX_SETUP_DIR=/var/cache/nginx</span><br><span class="line"></span><br><span class="line"><span class="comment"># 设置构建时变量，镜像建立完成后就失效</span></span><br><span class="line"><span class="keyword">ARG</span> BUILD_LIBAV=false</span><br><span class="line"><span class="keyword">ARG</span> WITH_DEBUG=false</span><br><span class="line"><span class="keyword">ARG</span> WITH_PAGESPEED=true</span><br><span class="line"><span class="keyword">ARG</span> WITH_RTMP=true</span><br><span class="line"></span><br><span class="line"><span class="comment"># 复制本地文件到容器目录中</span></span><br><span class="line"><span class="keyword">COPY</span><span class="bash"> setup/ <span class="variable">$&#123;NGINX_SETUP_DIR&#125;</span>/</span></span><br><span class="line"><span class="bash">RUN bash <span class="variable">$&#123;NGINX_SETUP_DIR&#125;</span>/install.sh</span></span><br><span class="line"><span class="bash"></span></span><br><span class="line"><span class="bash"><span class="comment"># 复制本地配置文件到容器目录中</span></span></span><br><span class="line"><span class="bash">COPY nginx.conf /etc/nginx/nginx.conf</span></span><br><span class="line"><span class="bash">COPY entrypoint.sh /sbin/entrypoint.sh</span></span><br><span class="line"><span class="bash"></span></span><br><span class="line"><span class="bash"><span class="comment"># 运行指令</span></span></span><br><span class="line"><span class="bash">RUN chmod 755 /sbin/entrypoint.sh</span></span><br><span class="line"><span class="bash"></span></span><br><span class="line"><span class="bash"><span class="comment"># 允许指定的端口</span></span></span><br><span class="line"><span class="bash">EXPOSE 80/tcp 443/tcp 1935/tcp</span></span><br><span class="line"><span class="bash"></span></span><br><span class="line"><span class="bash"><span class="comment"># 指定网站目录挂载点</span></span></span><br><span class="line"><span class="bash">VOLUME [<span class="string">"<span class="variable">$&#123;NGINX_SITECONF_DIR&#125;</span>"</span>]</span></span><br><span class="line"><span class="bash"></span></span><br><span class="line"><span class="bash">ENTRYPOINT [<span class="string">"/sbin/entrypoint.sh"</span>]</span></span><br><span class="line"><span class="bash">CMD [<span class="string">"/usr/sbin/nginx"</span>]</span></span><br></pre></td></tr></table></figure>
<h2 id="构建tomcat-环境"><a href="#构建tomcat-环境" class="headerlink" title="构建tomcat 环境"></a>构建tomcat 环境</h2><figure class="highlight dockerfile"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br><span class="line">5</span><br><span class="line">6</span><br><span class="line">7</span><br><span class="line">8</span><br><span class="line">9</span><br><span class="line">10</span><br><span class="line">11</span><br><span class="line">12</span><br><span class="line">13</span><br><span class="line">14</span><br><span class="line">15</span><br><span class="line">16</span><br><span class="line">17</span><br><span class="line">18</span><br><span class="line">19</span><br><span class="line">20</span><br><span class="line">21</span><br><span class="line">22</span><br><span class="line">23</span><br><span class="line">24</span><br><span class="line">25</span><br><span class="line">26</span><br><span class="line">27</span><br><span class="line">28</span><br><span class="line">29</span><br><span class="line">30</span><br><span class="line">31</span><br><span class="line">32</span><br><span class="line">33</span><br><span class="line">34</span><br><span class="line">35</span><br><span class="line">36</span><br><span class="line">37</span><br><span class="line">38</span><br><span class="line">39</span><br><span class="line">40</span><br><span class="line">41</span><br><span class="line">42</span><br><span class="line">43</span><br></pre></td><td class="code"><pre><span class="line"><span class="comment"># 指定基于的基础镜像</span></span><br><span class="line"><span class="keyword">FROM</span> ubuntu:<span class="number">13.10</span>  </span><br><span class="line"></span><br><span class="line"><span class="comment"># 维护者信息</span></span><br><span class="line"><span class="keyword">MAINTAINER</span> zhangjiayang <span class="string">"zhangjiayang@sczq.com.cn"</span>  </span><br><span class="line">  </span><br><span class="line"><span class="comment"># 镜像的指令操作</span></span><br><span class="line"><span class="comment"># 获取APT更新的资源列表</span></span><br><span class="line"><span class="keyword">RUN</span><span class="bash"> <span class="built_in">echo</span> <span class="string">"deb http://archive.ubuntu.com/ubuntu precise main universe"</span>&gt; /etc/apt/sources.list</span></span><br><span class="line"><span class="bash"><span class="comment"># 更新软件</span></span></span><br><span class="line"><span class="bash">RUN apt-get update  </span></span><br><span class="line"><span class="bash">  </span></span><br><span class="line"><span class="bash"><span class="comment"># Install curl  </span></span></span><br><span class="line"><span class="bash">RUN apt-get -y install curl  </span></span><br><span class="line"><span class="bash">  </span></span><br><span class="line"><span class="bash"><span class="comment"># Install JDK 7  </span></span></span><br><span class="line"><span class="bash">RUN <span class="built_in">cd</span> /tmp &amp;&amp;  curl -L <span class="string">'http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz'</span> -H <span class="string">'Cookie: oraclelicense=accept-securebackup-cookie; gpw_e24=Dockerfile'</span> | tar -xz  </span></span><br><span class="line"><span class="bash">RUN mkdir -p /usr/lib/jvm  </span></span><br><span class="line"><span class="bash">RUN mv /tmp/jdk1.7.0_65/ /usr/lib/jvm/java-7-oracle/  </span></span><br><span class="line"><span class="bash">  </span></span><br><span class="line"><span class="bash"><span class="comment"># Set Oracle JDK 7 as default Java  </span></span></span><br><span class="line"><span class="bash">RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-7-oracle/bin/java 300     </span></span><br><span class="line"><span class="bash">RUN update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-7-oracle/bin/javac 300     </span></span><br><span class="line"><span class="bash"></span></span><br><span class="line"><span class="bash"><span class="comment"># 设置系统环境</span></span></span><br><span class="line"><span class="bash">ENV JAVA_HOME /usr/lib/jvm/java-7-oracle/  </span></span><br><span class="line"><span class="bash">  </span></span><br><span class="line"><span class="bash"><span class="comment"># Install tomcat7  </span></span></span><br><span class="line"><span class="bash">RUN <span class="built_in">cd</span> /tmp &amp;&amp; curl -L <span class="string">'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.8/bin/apache-tomcat-7.0.8.tar.gz'</span> | tar -xz  </span></span><br><span class="line"><span class="bash">RUN mv /tmp/apache-tomcat-7.0.8/ /opt/tomcat7/  </span></span><br><span class="line"><span class="bash">  </span></span><br><span class="line"><span class="bash">ENV CATALINA_HOME /opt/tomcat7  </span></span><br><span class="line"><span class="bash">ENV PATH <span class="variable">$PATH</span>:<span class="variable">$CATALINA_HOME</span>/bin  </span></span><br><span class="line"><span class="bash"></span></span><br><span class="line"><span class="bash"><span class="comment"># 复件tomcat7.sh到容器中的目录 </span></span></span><br><span class="line"><span class="bash">ADD tomcat7.sh /etc/init.d/tomcat7  </span></span><br><span class="line"><span class="bash">RUN chmod 755 /etc/init.d/tomcat7  </span></span><br><span class="line"><span class="bash">  </span></span><br><span class="line"><span class="bash"><span class="comment"># Expose ports.  指定暴露的端口</span></span></span><br><span class="line"><span class="bash">EXPOSE 8080  </span></span><br><span class="line"><span class="bash">  </span></span><br><span class="line"><span class="bash"><span class="comment"># Define default command.  </span></span></span><br><span class="line"><span class="bash">ENTRYPOINT service tomcat7 start &amp;&amp; tail -f /opt/tomcat7/logs/catalina.out</span></span><br></pre></td></tr></table></figure>
<p>tomcat7.sh命令文件<br><figure class="highlight stata"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br><span class="line">5</span><br><span class="line">6</span><br><span class="line">7</span><br><span class="line">8</span><br><span class="line">9</span><br><span class="line">10</span><br><span class="line">11</span><br><span class="line">12</span><br><span class="line">13</span><br><span class="line">14</span><br><span class="line">15</span><br><span class="line">16</span><br></pre></td><td class="code"><pre><span class="line">export JAVA_HOME=/usr/lib/jvm/java-7-oracle/  </span><br><span class="line">export TOMCAT_HOME=/opt/tomcat7  </span><br><span class="line">  </span><br><span class="line">case <span class="variable">$1</span> <span class="keyword">in</span>  </span><br><span class="line">start)  </span><br><span class="line">  <span class="keyword">sh</span> <span class="variable">$TOMCAT_HOME</span>/bin/startup.<span class="keyword">sh</span>  </span><br><span class="line">;;  </span><br><span class="line">stop)  </span><br><span class="line">  <span class="keyword">sh</span> <span class="variable">$TOMCAT_HOME</span>/bin/shutdown.<span class="keyword">sh</span>  </span><br><span class="line">;;  </span><br><span class="line">restart)  </span><br><span class="line">  <span class="keyword">sh</span> <span class="variable">$TOMCAT_HOME</span>/bin/shutdown.<span class="keyword">sh</span>  </span><br><span class="line">  <span class="keyword">sh</span> <span class="variable">$TOMCAT_HOME</span>/bin/startup.<span class="keyword">sh</span>  </span><br><span class="line">;;  </span><br><span class="line">esac  </span><br><span class="line"><span class="keyword">exit</span> 0</span><br></pre></td></tr></table></figure></p>
<h2 id="原则与建议"><a href="#原则与建议" class="headerlink" title="原则与建议"></a>原则与建议</h2><ul>
<li>容器轻量化。从镜像中产生的容器应该尽量轻量化，能在足够短的时间内停止、销毁、重新生成并替换原来的容器。</li>
<li>使用 .gitignore。在大部分情况下，Dockerfile 会和构建所需的文件放在同一个目录中，为了提高构建的性能，应该使用 .gitignore 来过滤掉不需要的文件和目录。</li>
<li>为了减少镜像的大小，减少依赖，仅安装需要的软件包。</li>
<li>一个容器只做一件事。解耦复杂的应用，分成多个容器，而不是所有东西都放在一个容器内运行。如一个 Python Web 应用，可能需要 Server、DB、Cache、MQ、Log 等几个容器。一个更加极端的说法：One process per container。</li>
<li>减少镜像的图层。不要多个 Label、ENV 等标签。</li>
<li>对续行的参数按照字母表排序，特别是使用apt-get install -y安装包的时候。</li>
<li>使用构建缓存。如果不想使用缓存，可以在构建的时候使用参数–no-cache=true来强制重新生成中间镜像。</li>
</ul>
<p><a href="http://www.ityouknow.com/docker/2018/03/12/docker-use-dockerfile.html" target="_blank" rel="noopener">Docker(二)：Dockerfile 使用介绍</a></p>
<p><a href="https://docs.docker.com/engine/reference/builder/#usage" target="_blank" rel="noopener">Dockerfile reference</a><br><a href="https://www.jianshu.com/p/cbce69c7a52f" target="_blank" rel="noopener">使用Dockerfile构建Docker镜像</a><br><a href="https://itbilu.com/linux/docker/VyhM5wPuz.html" target="_blank" rel="noopener">Docker镜像构建文件Dockerfile及相关命令介绍</a><br><a href="https://github.com/qianlei90/Blog/issues/35" target="_blank" rel="noopener">深入Dockerfile（一）: 语法指南</a><br><a href="https://yeasy.gitbooks.io/docker_practice/content/" target="_blank" rel="noopener">Docker — 从入门到实践</a></p>
<p>保存下来形成镜像<br><figure class="highlight dsconfig"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br></pre></td><td class="code"><pre><span class="line"><span class="string">docker </span><span class="string">commit </span><span class="built_in">--author</span> <span class="string">"sunday"</span> <span class="built_in">--message</span> <span class="string">"chmod nginx index.html"</span> <span class="string">webserver </span><span class="string">nginx:v2</span></span><br><span class="line"><span class="string">docker </span><span class="string">run </span><span class="built_in">--name</span> <span class="string">web2 </span>-d -p <span class="string">81:80 </span><span class="string">nginx:v2</span></span><br></pre></td></tr></table></figure></p>
<p>不建议使用docker commit 制作镜像</p>
<h1 id="导出与导入"><a href="#导出与导入" class="headerlink" title="导出与导入"></a>导出与导入</h1><p>导出容器<br>如果要导出本地某个容器，可以使用 docker export 命令。<br><figure class="highlight shell"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br></pre></td><td class="code"><pre><span class="line"><span class="meta">$</span><span class="bash"> docker container ls -a</span></span><br><span class="line">CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                    PORTS               NAMES</span><br><span class="line">7691a814370e        ubuntu:14.04        "/bin/bash"         36 hours ago        Exited (0) 21 hours ago                       test</span><br><span class="line"><span class="meta">$</span><span class="bash"> docker <span class="built_in">export</span> 7691a814370e &gt; ubuntu.tar</span></span><br></pre></td></tr></table></figure></p>
<p>这样将导出容器快照到本地文件。</p>
<p>导入容器快照<br>可以使用 docker import 从容器快照文件中再导入为镜像，例如<br><figure class="highlight shell"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br></pre></td><td class="code"><pre><span class="line"><span class="meta">$</span><span class="bash"> cat ubuntu.tar | docker import - <span class="built_in">test</span>/ubuntu:v1.0</span></span><br><span class="line"><span class="meta">$</span><span class="bash"> docker image ls</span></span><br><span class="line">REPOSITORY          TAG                 IMAGE ID            CREATED              VIRTUAL SIZE</span><br><span class="line">test/ubuntu         v1.0                9d37a6082e97        About a minute ago   171.3 MB</span><br></pre></td></tr></table></figure></p>
<p>此外，也可以通过指定 URL 或者某个目录来导入，例如</p>
<p>$ docker import <a href="http://example.com/exampleimage.tgz" target="_blank" rel="noopener">http://example.com/exampleimage.tgz</a> example/imagerepo</p>
<h1 id="私有仓库"><a href="#私有仓库" class="headerlink" title="私有仓库"></a>私有仓库</h1><figure class="highlight x86asm"><table><tr><td class="gutter"><pre><span class="line">1</span><br><span class="line">2</span><br><span class="line">3</span><br><span class="line">4</span><br></pre></td><td class="code"><pre><span class="line">docker run -d -p <span class="number">5000</span>:<span class="number">5000</span> registry</span><br><span class="line">curl <span class="number">192.168</span><span class="meta">.77</span><span class="meta">.100</span>:<span class="number">5000</span>/v1/search</span><br><span class="line">docker tag  nginx:v3 <span class="number">192.168</span><span class="meta">.77</span><span class="meta">.100</span>:<span class="number">5000</span>/nginx:latest</span><br><span class="line">docker <span class="keyword">push</span> https://<span class="number">192.168</span><span class="meta">.77</span><span class="meta">.100</span>:<span class="number">5000</span>/nginx:latest</span><br></pre></td></tr></table></figure>

                <hr>

                

                <ul class="pager">
                    
                    
                        <li class="next">
                            <a href="/docker" data-toggle="tooltip" data-placement="top" title="Docker(一)：Docker入门">Next Post &rarr;</a>
                        </li>
                    
                </ul>

                

                

            </div>
    <!-- Side Catalog Container -->
        
            <div class="
                col-lg-2 col-lg-offset-0
                visible-lg-block
                sidebar-container
                catalog-container">
                <div class="side-catalog">
                    <hr class="hidden-sm hidden-xs">
                    <h5>
                        <a class="catalog-toggle" href="#">CATALOG</a>
                    </h5>
                    <ul class="catalog-body"></ul>
                </div>
            </div>
        

    <!-- Sidebar Container -->

            <div class="
                col-lg-8 col-lg-offset-2
                col-md-10 col-md-offset-1
                sidebar-container">

                <!-- Featured Tags -->
                
                <section>
                    <!-- no hr -->
                    <h5><a href="/tags/">FEATURED TAGS</a></h5>
                    <div class="tags">
                       
                          <a class="tag" href="/tags/#docker" title="docker">docker</a>
                        
                    </div>
                </section>
                

                <!-- Friends Blog -->
                
                <hr>
                <h5>FRIENDS</h5>
                <ul class="list-inline">

                    
                        <li><a href="https://jaminzhang.github.io" target="_blank">JAMIN ZHANG</a></li>
                    
                        <li><a href="#" target="_blank">It helps SEO</a></li>
                    
                </ul>
                
            </div>

        </div>
    </div>
</article>







<!-- async load function -->
<script>
    function async(u, c) {
      var d = document, t = 'script',
          o = d.createElement(t),
          s = d.getElementsByTagName(t)[0];
      o.src = u;
      if (c) { o.addEventListener('load', function (e) { c(null, e); }, false); }
      s.parentNode.insertBefore(o, s);
    }
</script>
<!-- anchor-js, Doc:http://bryanbraun.github.io/anchorjs/ -->
<script>
    async("https://cdnjs.cloudflare.com/ajax/libs/anchor-js/1.1.1/anchor.min.js",function(){
        anchors.options = {
          visible: 'always',
          placement: 'right',
          icon: '#'
        };
        anchors.add().remove('.intro-header h1').remove('.subheading').remove('.sidebar-container h5');
    })
</script>
<style>
    /* place left on bigger screen */
    @media all and (min-width: 800px) {
        .anchorjs-link{
            position: absolute;
            left: -0.75em;
            font-size: 1.1em;
            margin-top : -0.1em;
        }
    }
</style>



    <!-- Footer -->
    <!-- Footer -->
<footer>
    <div class="container">
        <div class="row">
            <div class="col-lg-8 col-lg-offset-2 col-md-10 col-md-offset-1">
                <ul class="list-inline text-center">
                
                
                

                

                

                
                    <li>
                        <a target="_blank"  href="https://github.com/sundayle">
                            <span class="fa-stack fa-lg">
                                <i class="fa fa-circle fa-stack-2x"></i>
                                <i class="fa fa-github fa-stack-1x fa-inverse"></i>
                            </span>
                        </a>
                    </li>
                

                

                </ul>
                <p class="copyright text-muted">
                    Copyright &copy; Sunday 2018 
                    <br>
                    Theme by <a href="http://huangxuan.me">Hux</a> 
                    <span style="display: inline-block; margin: 0 5px;">
                        <i class="fa fa-heart"></i>
                    </span>
                    Ported by <a href="https://github.com/Kaijun/hexo-theme-huxblog">Kaijun</a>
            <!-- 
                    Ported by <a href="http://blog.kaijun.rocks">Kaijun</a> | 
                    <iframe
                        style="margin-left: 2px; margin-bottom:-5px;"
                        frameborder="0" scrolling="0" width="91px" height="20px"
                        src="https://ghbtns.com/github-btn.html?user=kaijun&repo=hexo-theme-huxblog&type=star&count=true" >
                    </iframe>
            -->
                </p>
            </div>
        </div>
    </div>
</footer>

<!-- jQuery -->
<script src="/js/jquery.min.js"></script>

<!-- Bootstrap Core JavaScript -->
<script src="/js/bootstrap.min.js"></script>

<!-- Custom Theme JavaScript -->
<script src="/js/hux-blog.min.js"></script>


<!-- async load function -->
<script>
    function async(u, c) {
      var d = document, t = 'script',
          o = d.createElement(t),
          s = d.getElementsByTagName(t)[0];
      o.src = u;
      if (c) { o.addEventListener('load', function (e) { c(null, e); }, false); }
      s.parentNode.insertBefore(o, s);
    }
</script>

<!-- 
     Because of the native support for backtick-style fenced code blocks 
     right within the Markdown is landed in Github Pages, 
     From V1.6, There is no need for Highlight.js, 
     so Huxblog drops it officially.

     - https://github.com/blog/2100-github-pages-now-faster-and-simpler-with-jekyll-3-0  
     - https://help.github.com/articles/creating-and-highlighting-code-blocks/    
-->
<!--
    <script>
        async("http://cdn.bootcss.com/highlight.js/8.6/highlight.min.js", function(){
            hljs.initHighlightingOnLoad();
        })
    </script>
    <link href="http://cdn.bootcss.com/highlight.js/8.6/styles/github.min.css" rel="stylesheet">
-->


<!-- jquery.tagcloud.js -->
<script>
    // only load tagcloud.js in tag.html
    if($('#tag_cloud').length !== 0){
        async("/js/jquery.tagcloud.js",function(){
            $.fn.tagcloud.defaults = {
                //size: {start: 1, end: 1, unit: 'em'},
                color: {start: '#bbbbee', end: '#0085a1'},
            };
            $('#tag_cloud a').tagcloud();
        })
    }
</script>

<!--fastClick.js -->
<script>
     async("https://cdnjs.cloudflare.com/ajax/libs/fastclick/1.0.6/fastclick.min.js", function(){
        var $nav = document.querySelector("nav");
        if($nav) FastClick.attach($nav);
    })
</script>


<!-- Google Analytics -->


<script>
    // dynamic User by Hux
    var _gaId = 'UA-70699634-1';
    var _gaDomain = 'auto';

    // Originial
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

    ga('create', _gaId, _gaDomain);
    ga('send', 'pageview');
</script>




<!-- Baidu Tongji -->


<!-- Side Catalog -->

<script type="text/javascript">
    function generateCatalog (selector) {
        var P = $('div.post-container'),a,n,t,l,i,c;
        a = P.find('h1,h2,h3,h4,h5,h6');
        a.each(function () {
            n = $(this).prop('tagName').toLowerCase();
            i = "#"+$(this).prop('id');
            t = $(this).text();
            c = $('<a href="'+i+'" rel="nofollow">'+t+'</a>');
            l = $('<li class="'+n+'_nav"></li>').append(c);
            $(selector).append(l);
        });
        return true;    
    }

    generateCatalog(".catalog-body");

    // toggle side catalog
    $(".catalog-toggle").click((function(e){
        e.preventDefault();
        $('.side-catalog').toggleClass("fold")
    }))

    /*
     * Doc: https://github.com/davist11/jQuery-One-Page-Nav
     * Fork by Hux to support padding
     */
    async("/js/jquery.nav.js", function () {
        $('.catalog-body').onePageNav({
            currentClass: "active",
            changeHash: !1,
            easing: "swing",
            filter: "",
            scrollSpeed: 700,
            scrollOffset: 0,
            scrollThreshold: .2,
            begin: null,
            end: null,
            scrollChange: null,
            padding: 80
        });
    });
</script>





<!-- Image to hack wechat -->
<img src="/img/icon_wechat.png" width="0" height="0" />
<!-- Migrate from head to bottom, no longer block render and still work -->

</body>

</html>
