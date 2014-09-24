class Qomo::Pubmed
  attr_accessor :pmids, :total, :publications

  def initialize
    @pmids = []
    @total = 0
    @publications = []
  end


  def self.search(query, page)
    page_size = 25
    base_url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils'

    retstart = (page - 1) * page_size
    esearch_url =  URI::encode "#{base_url}/esearch.fcgi?db=pubmed&term=#{query}&retmax=#{page_size}&retstart=#{retstart}"
    doc = Nokogiri::XML(open esearch_url)

    result = new
    result.total = doc.xpath('/eSearchResult/Count').first.content.to_i

    doc.xpath('/eSearchResult/IdList/Id').each {|n| result.pmids << n.content}
    result.publications = find_by_pmids result.pmids
    result
  end


  def self.find_by_pmids(pmids)
    base_url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils'
    publications = []
    efetch_url =  URI::encode "#{base_url}/efetch.fcgi?db=pubmed&id=#{pmids.join ','}&retmode=xml"

    doc = Nokogiri::XML(open efetch_url)

    doc.xpath('/PubmedArticleSet/PubmedArticle/MedlineCitation').each do |n|
      published_at = Date.new n.xpath('DateCreated/Year')[0].content.to_i,
                              n.xpath('DateCreated/Month')[0].content.to_i,
                              n.xpath('DateCreated/Day')[0].content.to_i

      authors = []
      n.xpath('Article/AuthorList/Author').each do |a|
        authors << "#{a.xpath('ForeName')[0].content} #{a.xpath('LastName')[0].content}"
      end

      pub = Publication.new pmid: n.xpath('PMID')[0].content,
                            published_at: published_at,
                            title: n.xpath('Article/ArticleTitle')[0].content,
                            authors: authors.join(', '),
                            journal: n.xpath('Article/Journal/Title')[0].content

      publications << pub
    end
    publications
  end


end
