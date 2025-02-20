class E11G1::Link
  @link : String
end

class E11G2::Sublink < E11G1::Link
  protected def my_method : Void; end
end

class E11G3::SubSublink < E11G2::Sublink
  private def my_another_method : Void; end
end

class E11G3::AnotherSubSublink < E11G2::Sublink
  private def my_another_method : Void; end
end
