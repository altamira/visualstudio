/****** Object:  XmlSchemaCollection [Security].[SessionResponseSchema]    Script Date: 01/17/2012 12:44:40 ******/
CREATE XML SCHEMA COLLECTION [Security].[SessionResponseSchema] AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema"><xsd:element name="error"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="message" type="xsd:string" /></xsd:sequence><xsd:attribute name="id" type="xsd:integer" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element><xsd:element name="session"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence /><xsd:attribute name="id" type="xsd:string" /><xsd:attribute name="userid" type="xsd:integer" /><xsd:attribute name="firstname" type="xsd:string" /><xsd:attribute name="lastname" type="xsd:string" /><xsd:attribute name="lastlogindate" type="xsd:string" /><xsd:attribute name="expiredate" type="xsd:string" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:schema>'




