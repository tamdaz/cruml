class E11::G1::Link;
  def my_public_method : Void; end
end

class E11::G2::Sublink < E11::G1::Link
  protected def my_method : Void; end
end

class E11::G3::SubSublink < E11::G2::Sublink
  private def my_another_method : Void; end
end

class E11::G3::AnotherSubSublink < E11::G2::Sublink
  private def my_another_method : Void; end
end
