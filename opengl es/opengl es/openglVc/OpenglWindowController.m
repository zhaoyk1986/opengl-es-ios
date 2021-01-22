//
//  OpenglWindowController.m
//  opengl es
//
//  Created by lotus on 2021/1/21.
//
 
#import "OpenglWindowController.h"

@interface OpenglWindowController (){
    
    /*opengl context
     管理使用opengl es 进行绘制的状态，命令，资源
    */
    EAGLContext * _eaglContext;
    CAEAGLLayer * _eaglLayer;
    
    GLuint _colorRenderBuffer; // 渲染缓冲区
    GLuint _frameBuffer; // 帧缓冲区
     
}
 
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation OpenglWindowController

-(void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:255];
           
    [self createBackButton];
    
    //
    [self setupGlContext];
    [self setupCAEAGLLayer];
    
    [self destoryRenderAndFrameBuffer];
    [self setupRenderAndFrameBuffer];
     
    [self Render];
//    glViewport(0, 0, _eaglLayer.frame.size.width/2, _eaglLayer.frame.size.height);
      
    [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)setupGlContext{
    
    //初始化渲染上下文，管理所有绘制的状态，
    //命令，及资源信息。
    
    //opengl es 2.0
    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //设置为当前上下文
    [EAGLContext setCurrentContext:_eaglContext];
}

-(void)setupCAEAGLLayer{
    
    int width = self.view.frame.size.width;
    int height = self.view.frame.size.height;
    
    //setup layer, 必须要是CAEAGLLayer才行，才能在其上描绘opengl内容
    //如果在vc中，使用 self.view.layer addSublayer.eaglLayer
    //如果在view中，可以直接重写uiview的layerclass类方法， return 【caeagllayer class】
    _eaglLayer = [CAEAGLLayer layer];
    _eaglLayer.frame = CGRectMake(25, 100, width - 50, height - 150);
    _eaglLayer.opaque = YES; //不透明度
    
    // 描绘属性：这里不维持渲染内容
    // kEAGLDrawablePropertyRetainedBacking:若为YES，则使用glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)计算得到的最终结果颜色的透明度会考虑目标颜色的透明度值。
    // 若为NO，则不考虑目标颜色的透明度值，将其当做1来处理。
    // 使用场景：目标颜色为非透明，源颜色有透明度，若设为YES，则使用glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)得到的结果颜色会有一定的透明度（与实际不符）。若未NO则不会（符合实际）。
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
    [self.view.layer addSublayer:_eaglLayer];
    
}

- (void)destoryRenderAndFrameBuffer {
    
    // 销毁渲染区和帧缓冲区
    if (_colorRenderBuffer) {
        glDeleteRenderbuffers(1, &_colorRenderBuffer);
        _colorRenderBuffer = 0;
    }
    
    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
}

// 初始化Render Frame Buffer
- (void)setupRenderAndFrameBuffer {
    
    //先要renderbuffer，然后framebuffer，顺序不能互换。
     
    // OpenGlES共有三种：colorBuffer，depthBuffer，stencilBuffer。
    // 生成一个renderBuffer，id是_colorRenderBuffer
    glGenRenderbuffers(1, &_colorRenderBuffer);
    // 设置为当前renderBuffer
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    //为color renderbuffer 分配存储空间
    [_eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    // FBO用于管理colorRenderBuffer，离屏渲染
    glGenFramebuffers(1, &_frameBuffer);
    //设置为当前framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

-(void)Render{
     
    //设置为当前framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    // 设置清屏颜色
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
    // 用来指定要用清屏颜色来清除由mask指定的buffer，此处是color buffer
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    
}

 
- (void)createBackButton {
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 45, 45)];
    [self.backButton setImage:[UIImage imageNamed:@"mod_close"] forState:UIControlStateNormal];
    self.backButton.adjustsImageWhenHighlighted = NO;
    [self.backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
}

#pragma mark - 点击事件
- (void)backClick:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
