/****** Object:  XmlSchemaCollection [Security].[SessionRequestSchema]    Script Date: 01/17/2012 12:44:40 ******/
CREATE XML SCHEMA COLLECTION [Security].[SessionRequestSchema] AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema"><xsd:element name="user"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="username" type="xsd:string" /><xsd:element name="password" type="xsd:string" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:schema>'




