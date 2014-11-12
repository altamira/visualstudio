CREATE XML SCHEMA COLLECTION [dbo].[XMLDSIG_CORE_SCHEMA_v101]
    AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.w3.org/2000/09/xmldsig#" targetNamespace="http://www.w3.org/2000/09/xmldsig#" elementFormDefault="qualified">
  <xsd:complexType name="SignatureValueType">
    <xsd:simpleContent>
      <xsd:extension base="xsd:base64Binary">
        <xsd:attribute name="Id" type="xsd:ID" />
      </xsd:extension>
    </xsd:simpleContent>
  </xsd:complexType>
  <xsd:element name="Signature" type="t:SignatureType" />
  <xsd:complexType name="KeyInfoType">
    <xsd:complexContent>
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence>
          <xsd:element name="X509Data" type="t:X509DataType" />
        </xsd:sequence>
        <xsd:attribute name="Id" type="xsd:ID" />
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
  <xsd:complexType name="ReferenceType">
    <xsd:complexContent>
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence>
          <xsd:element name="Transforms" type="t:TransformsType" />
          <xsd:element name="DigestMethod">
            <xsd:complexType>
              <xsd:complexContent>
                <xsd:restriction base="xsd:anyType">
                  <xsd:sequence />
                  <xsd:attribute name="Algorithm" type="xsd:anyURI" use="required" fixed="http://www.w3.org/2000/09/xmldsig#sha1" />
                </xsd:restriction>
              </xsd:complexContent>
            </xsd:complexType>
          </xsd:element>
          <xsd:element name="DigestValue" type="t:DigestValueType" />
        </xsd:sequence>
        <xsd:attribute name="Id" type="xsd:ID" />
        <xsd:attribute name="URI" use="required">
          <xsd:simpleType>
            <xsd:restriction base="xsd:anyURI">
              <xsd:minLength value="2" />
            </xsd:restriction>
          </xsd:simpleType>
        </xsd:attribute>
        <xsd:attribute name="Type" type="xsd:anyURI" />
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
  <xsd:complexType name="SignatureType">
    <xsd:complexContent>
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence>
          <xsd:element name="SignedInfo" type="t:SignedInfoType" />
          <xsd:element name="SignatureValue" type="t:SignatureValueType" />
          <xsd:element name="KeyInfo" type="t:KeyInfoType" />
        </xsd:sequence>
        <xsd:attribute name="Id" type="xsd:ID" />
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
  <xsd:complexType name="SignedInfoType">
    <xsd:complexContent>
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence>
          <xsd:element name="CanonicalizationMethod">
            <xsd:complexType>
              <xsd:complexContent>
                <xsd:restriction base="xsd:anyType">
                  <xsd:sequence />
                  <xsd:attribute name="Algorithm" type="xsd:anyURI" use="required" fixed="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
                </xsd:restriction>
              </xsd:complexContent>
            </xsd:complexType>
          </xsd:element>
          <xsd:element name="SignatureMethod">
            <xsd:complexType>
              <xsd:complexContent>
                <xsd:restriction base="xsd:anyType">
                  <xsd:sequence />
                  <xsd:attribute name="Algorithm" type="xsd:anyURI" use="required" fixed="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />
                </xsd:restriction>
              </xsd:complexContent>
            </xsd:complexType>
          </xsd:element>
          <xsd:element name="Reference" type="t:ReferenceType" />
        </xsd:sequence>
        <xsd:attribute name="Id" type="xsd:ID" />
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
  <xsd:complexType name="TransformType">
    <xsd:complexContent>
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence minOccurs="0" maxOccurs="unbounded">
          <xsd:element name="XPath" type="xsd:string" />
        </xsd:sequence>
        <xsd:attribute name="Algorithm" type="t:TTransformURI" use="required" />
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
  <xsd:complexType name="TransformsType">
    <xsd:complexContent>
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence>
          <xsd:element name="Transform" type="t:TransformType" minOccurs="2" maxOccurs="2" />
        </xsd:sequence>
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
  <xsd:complexType name="X509DataType">
    <xsd:complexContent>
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence>
          <xsd:element name="X509Certificate" type="xsd:base64Binary" />
        </xsd:sequence>
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
  <xsd:simpleType name="DigestValueType">
    <xsd:restriction base="xsd:base64Binary" />
  </xsd:simpleType>
  <xsd:simpleType name="TTransformURI">
    <xsd:restriction base="xsd:anyURI">
      <xsd:enumeration value="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
      <xsd:enumeration value="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
    </xsd:restriction>
  </xsd:simpleType>
</xsd:schema>';

