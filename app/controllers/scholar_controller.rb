class ScholarController < ApplicationController

  def index
    @user = current_user
  end


  def user
    @user = User.find params['id']
    render 'index'
  end


  def pubmed_search
  end


  def do_pubmed_search
    begin
      page = params['page'].to_i
      unless page > 0
        page = 1
      end

      params['page'] = page

      @result = Qomo::Pubmed.search params['query'], page
    rescue

    end

    render 'pubmed_search'
  end


  def publications_add
    pub = Publication.find_by_pmid params['pmid']

    unless pub
      pub = (Qomo::Pubmed.find_by_pmids [params['pmid']])[0]
      pub.save
    end


    pub.users << current_user

    pub.save

    render json: {}
  end


  def publications_del
    pub = Publication.find_by_pmid params['pmid']
    pub.users.delete current_user
    render json: {}
  end

end
