class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :find_user, :only => [:edit, :update, :destroy]
  before_filter :require_user, :only => [:edit, :update, :destroy]
  before_filter :require_self, :only => [:edit, :update, :destroy]
  
  def find_user
    @user = User.find(params[:id])
  end
  
  def require_self
    redirect_to :root unless @user == current_user
  end

  # GET /users/1/edit
  def edit
    
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save_without_session_maintenance
        UserMailer.account_activation(@user).deliver
        format.html { redirect_to(root_path, :notice => "Benutzer wurde angelegt, und eine E-Mail mit Aktivierungslink wurde an <strong>#{@user.email}</strong> geschickt.") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "Passwort wurde geändert." unless params[:user][:password].blank?
        format.html { redirect_to(root_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    #current_user_session.destroy
    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to(home_url) }
      format.xml  { head :ok }
    end
  end
  
  def welcome
    @user = User.new
  end
end
