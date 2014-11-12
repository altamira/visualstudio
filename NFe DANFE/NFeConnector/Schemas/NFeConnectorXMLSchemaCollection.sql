﻿--DROP XML SCHEMA COLLECTION [NFe_v200_XMLSchemaCollection]

CREATE XML SCHEMA COLLECTION [NFe_v200_XMLSchemaCollection] AS
N'<?xml version="1.0" encoding="UTF-16"?>
<xs:schema xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.portalfiscal.inf.br/nfe" targetNamespace="http://www.portalfiscal.inf.br/nfe" elementFormDefault="qualified" attributeFormDefault="unqualified">
    <xs:import namespace="http://www.w3.org/2000/09/xmldsig#" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" />
	<xs:element name="Signature" type="SignatureType" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" />
	<xs:complexType name="SignatureType" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" >
		<xs:sequence>
			<xs:element name="SignedInfo" type="SignedInfoType" />
			<xs:element name="SignatureValue" type="SignatureValueType"/>
			<xs:element name="KeyInfo" type="KeyInfoType"/>
		</xs:sequence>
		<xs:attribute name="Id" type="xs:ID" use="optional"/>
	</xs:complexType>
	<xs:complexType name="SignatureValueType" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" >
		<xs:simpleContent>
			<xs:extension base="xs:base64Binary">
				<xs:attribute name="Id" type="xs:ID" use="optional"/>
			</xs:extension>
		</xs:simpleContent>
	</xs:complexType>
	<xs:complexType name="SignedInfoType" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" >
		<xs:sequence>
			<xs:element name="CanonicalizationMethod">
				<xs:complexType>
					<xs:attribute name="Algorithm" type="xs:anyURI" use="required" fixed="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>
				</xs:complexType>
			</xs:element>
			<xs:element name="SignatureMethod">
				<xs:complexType>
					<xs:attribute name="Algorithm" type="xs:anyURI" use="required" fixed="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
				</xs:complexType>
			</xs:element>
			<xs:element name="Reference" type="ReferenceType"/>
		</xs:sequence>
		<xs:attribute name="Id" type="xs:ID" use="optional"/>
	</xs:complexType>
	<xs:complexType name="ReferenceType" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" >
		<xs:sequence>
			<xs:element name="Transforms" type="TransformsType">
				<!-- Garante a unicidade do atributo -->
				<!--<unique name="unique_Transf_Alg">
					<selector xpath="./*"/>
					<field xpath="@Algorithm"/>
				</unique>-->
			</xs:element>
			<xs:element name="DigestMethod">
				<xs:complexType>
					<xs:attribute name="Algorithm" type="xs:anyURI" use="required" fixed="http://www.w3.org/2000/09/xmldsig#sha1"/>
				</xs:complexType>
			</xs:element>
			<xs:element name="DigestValue" type="DigestValueType"/>
		</xs:sequence>
		<xs:attribute name="Id" type="xs:ID" use="optional"/>
		<xs:attribute name="URI" use="required">
			<xs:simpleType>
				<xs:restriction base="xs:anyURI">
					<xs:minLength value="2"/>
				</xs:restriction>
			</xs:simpleType>
		</xs:attribute>
		<xs:attribute name="Type" type="xs:anyURI" use="optional"/>
	</xs:complexType>
	<xs:complexType name="TransformsType" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" >
		<xs:sequence>
			<xs:element name="Transform" type="TransformType" minOccurs="2" maxOccurs="2"/>
		</xs:sequence>
	</xs:complexType>
	<xs:complexType name="TransformType" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" >
		<xs:sequence minOccurs="0" maxOccurs="unbounded">
			<xs:element name="XPath" type="xs:string"/>
		</xs:sequence>
		<xs:attribute name="Algorithm" type="TTransformURI" use="required"/>
	</xs:complexType>
	<xs:complexType name="KeyInfoType" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" >
		<xs:sequence>
			<xs:element name="X509Data" type="X509DataType"/>
		</xs:sequence>
		<xs:attribute name="Id" type="xs:ID" use="optional"/>
	</xs:complexType>
	<xs:complexType name="X509DataType" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" >
		<xs:sequence>
			<xs:element name="X509Certificate" type="xs:base64Binary"/>
		</xs:sequence>
	</xs:complexType>
	<xs:simpleType name="DigestValueType" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" >
		<xs:restriction base="xs:base64Binary"/>
	</xs:simpleType>
	<xs:simpleType name="TTransformURI" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" >
		<xs:restriction base="xs:anyURI">
			<xs:enumeration value="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
			<xs:enumeration value="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>
		</xs:restriction>
	</xs:simpleType>
	<!-- end ds -->
	<xs:simpleType name="TCodUfIBGE">
		<xs:annotation>
			<xs:documentation>Tipo Código da UF da tabela do IBGE</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="11"/>
			<xs:enumeration value="12"/>
			<xs:enumeration value="13"/>
			<xs:enumeration value="14"/>
			<xs:enumeration value="15"/>
			<xs:enumeration value="16"/>
			<xs:enumeration value="17"/>
			<xs:enumeration value="21"/>
			<xs:enumeration value="22"/>
			<xs:enumeration value="23"/>
			<xs:enumeration value="24"/>
			<xs:enumeration value="25"/>
			<xs:enumeration value="26"/>
			<xs:enumeration value="27"/>
			<xs:enumeration value="28"/>
			<xs:enumeration value="29"/>
			<xs:enumeration value="31"/>
			<xs:enumeration value="32"/>
			<xs:enumeration value="33"/>
			<xs:enumeration value="35"/>
			<xs:enumeration value="41"/>
			<xs:enumeration value="42"/>
			<xs:enumeration value="43"/>
			<xs:enumeration value="50"/>
			<xs:enumeration value="51"/>
			<xs:enumeration value="52"/>
			<xs:enumeration value="53"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TCodMunIBGE">
		<xs:annotation>
			<xs:documentation>Tipo Código do Município da tabela do IBGE</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{7}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TChNFe">
		<xs:annotation>
			<xs:documentation>Tipo Chave da Nota Fiscal Eletrônica</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{44}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TProt">
		<xs:annotation>
			<xs:documentation>Tipo Número do Protocolo de Status</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{15}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TRec">
		<xs:annotation>
			<xs:documentation>Tipo Número do Recibo do envio de lote de NF-e</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{15}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TStat">
		<xs:annotation>
			<xs:documentation>Tipo Código da Mensagem enviada</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{3}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TCnpj">
		<xs:annotation>
			<xs:documentation>Tipo Número do CNPJ</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{14}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TCnpjVar">
		<xs:annotation>
			<xs:documentation>Tipo Número do CNPJ tmanho varíavel (3-14)</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{3,14}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TCnpjOpc">
		<xs:annotation>
			<xs:documentation>Tipo Número do CNPJ Opcional</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{0}|[0-9]{14}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TCpf">
		<xs:annotation>
			<xs:documentation>Tipo Número do CPF</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{11}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TCpfVar">
		<xs:annotation>
			<xs:documentation>Tipo Número do CPF de tamanho variável (3-11)</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{3,11}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_0302">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 5 dígitos, sendo 3 de corpo e 2 decimais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0|0\.[0-9]{2}|[1-9]{1}[0-9]{0,2}(\.[0-9]{2})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_0302Opc">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 5 dígitos, sendo 3 de corpo e 2 decimais, utilizado em tags opcionais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0\.[0-9]{1}[1-9]{1}|0\.[1-9]{1}[0-9]{1}|[1-9]{1}[0-9]{0,2}(\.[0-9]{2})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_0803">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 11 dígitos, sendo 8 de corpo e 3 decimais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0|0\.[0-9]{3}|[1-9]{1}[0-9]{0,7}(\.[0-9]{3})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_0803Opc">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 11 dígitos, sendo 8 de corpo e 3 decimais utilizado em tags opcionais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0\.[1-9]{1}[0-9]{2}|0\.[0-9]{2}[1-9]{1}|0\.[0-9]{1}[1-9]{1}[0-9]{1}|[1-9]{1}[0-9]{0,7}(\.[0-9]{3})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_0804">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 12 dígitos, sendo 8 de corpo e 4decimais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0|0\.[0-9]{4}|[1-9]{1}[0-9]{0,7}(\.[0-9]{4})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_0804Opc">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 12 dígitos, sendo 8 de corpo e 4 decimais, utilizado em tags opcionais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0\.[1-9]{1}[0-9]{3}|0\.[0-9]{3}[1-9]{1}|0\.[0-9]{2}[1-9]{1}[0-9]{1}|0\.[0-9]{1}[1-9]{1}[0-9]{2}|[1-9]{1}[0-9]{0,7}(\.[0-9]{4})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_1104">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 15 dígitos, sendo 11 de corpo e 4 decimais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0|0\.[0-9]{4}|[1-9]{1}[0-9]{0,10}(\.[0-9]{4})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_1104Opc">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 15 dígitos, sendo 11 de corpo e 4 decimais, utilizado em tags opcionais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0\.[1-9]{1}[0-9]{3}|0\.[0-9]{3}[1-9]{1}|0\.[0-9]{2}[1-9]{1}[0-9]{1}|0\.[0-9]{1}[1-9]{1}[0-9]{2}|[1-9]{1}[0-9]{0,10}(\.[0-9]{4})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_1203">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 15 dígitos, sendo 12 de corpo e 3 decimais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0|0\.[0-9]{3}|[1-9]{1}[0-9]{0,11}(\.[0-9]{3})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_1203Opc">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 15 dígitos, sendo 12 de corpo e 3 decimais, utilizado em tags opcionais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0\.[1-9]{1}[0-9]{2}|0\.[0-9]{2}[1-9]{1}|0\.[0-9]{1}[1-9]{1}[0-9]{1}|[1-9]{1}[0-9]{0,11}(\.[0-9]{3})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_1204">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 16 dígitos, sendo 12 de corpo e 4 decimais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0|0\.[0-9]{1,4}|[1-9]{1}[0-9]{0,11}|[1-9]{1}[0-9]{0,11}(\.[0-9]{1,4})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_1204Opc">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 16 dígitos, sendo 12 de corpo e 4 decimais, utilizado em tags opcionais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0\.[1-9]{1}[0-9]{3}|0\.[0-9]{3}[1-9]{1}|0\.[0-9]{2}[1-9]{1}[0-9]{1}|0\.[0-9]{1}[1-9]{1}[0-9]{2}|[1-9]{1}[0-9]{0,11}(\.[0-9]{4})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_1302">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 15 dígitos, sendo 13 de corpo e 2 decimais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0|0\.[0-9]{2}|[1-9]{1}[0-9]{0,12}(\.[0-9]{2})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_1302Opc">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com 15 dígitos, sendo 13 de corpo e 2 decimais, utilizado em tags opcionais</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0\.[0-9]{1}[1-9]{1}|0\.[1-9]{1}[0-9]{1}|[1-9]{1}[0-9]{0,12}(\.[0-9]{2})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_1110">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com até  21 dígitos, sendo 11 de corpo e até 10 decimais // aperfeiçoamento v2.0</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0|0\.[0-9]{1,10}|[1-9]{1}[0-9]{0,10}|[1-9]{1}[0-9]{0,10}(\.[0-9]{1,10})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TDec_1104v">
		<xs:annotation>
			<xs:documentation>Tipo Decimal com até 15 dígitos, sendo 11 de corpo e até 4 decimais  // aperfeiçoamento v2.0</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0|0\.[0-9]{1,4}|[1-9]{1}[0-9]{0,10}|[1-9]{1}[0-9]{0,10}(\.[0-9]{1,4})?"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TIeDest">
		<xs:annotation>
			<xs:documentation>Tipo Inscrição Estadual do Destinatário // alterado para aceitar vazio ou ISENTO - maio/2010 v2.0</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="ISENTO|[0-9]{0,14}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TIeST">
		<xs:annotation>
			<xs:documentation>Tipo Inscrição Estadual do ST // acrescentado EM 24/10/08</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{2,14}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TIe">
		<xs:annotation>
			<xs:documentation>Tipo Inscrição Estadual do Emitente // alterado EM 24/10/08 para aceitar ISENTO</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{2,14}|ISENTO"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TMod">
		<xs:annotation>
			<xs:documentation>Tipo Modelo Documento Fiscal</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="55"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TNF">
		<xs:annotation>
			<xs:documentation>Tipo Número do Documento Fiscal</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[1-9]{1}[0-9]{0,8}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TSerie">
		<xs:annotation>
			<xs:documentation>Tipo Série do Documento Fiscal </xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="0|[1-9]{1}[0-9]{0,2}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="Tpais">
		<xs:annotation>
			<xs:documentation>Tipo Código do Pais 
// PL_005d - 11/08/09
eliminado:
 4235-LEBUAN, ILHAS - 
acrescentado:
7200 SAO TOME E PRINCIPE, ILHAS,
8958 ZONA DO CANAL DO PANAMA               
9903 PROVISAO DE NAVIOS E AERONAVES        
9946 A DESIGNAR                            
9950 BANCOS CENTRAIS                       
9970 ORGANIZACOES INTERNACIONAIS
 // PL_005b - 24/10/08
 // Acrescentado:
 4235 - LEBUAN,ILHAS
 4885 - MAYOTTE (ILHAS FRANCESAS)  
// NT2011/004
 acrescentado a tabela de paises</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="132"/>
			<xs:enumeration value="175"/>
			<xs:enumeration value="230"/>
			<xs:enumeration value="310"/>
			<xs:enumeration value="370"/>
			<xs:enumeration value="400"/>
			<xs:enumeration value="418"/>
			<xs:enumeration value="434"/>
			<xs:enumeration value="477"/>
			<xs:enumeration value="531"/>
			<xs:enumeration value="590"/>
			<xs:enumeration value="639"/>
			<xs:enumeration value="647"/>
			<xs:enumeration value="655"/>
			<xs:enumeration value="698"/>
			<xs:enumeration value="728"/>
			<xs:enumeration value="736"/>
			<xs:enumeration value="779"/>
			<xs:enumeration value="809"/>
			<xs:enumeration value="817"/>
			<xs:enumeration value="833"/>
			<xs:enumeration value="850"/>
			<xs:enumeration value="876"/>
			<xs:enumeration value="884"/>
			<xs:enumeration value="906"/>
			<xs:enumeration value="930"/>
			<xs:enumeration value="973"/>
			<xs:enumeration value="981"/>
			<xs:enumeration value="0132"/>
			<xs:enumeration value="0175"/>
			<xs:enumeration value="0230"/>
			<xs:enumeration value="0310"/>
			<xs:enumeration value="0370"/>
			<xs:enumeration value="0400"/>
			<xs:enumeration value="0418"/>
			<xs:enumeration value="0434"/>
			<xs:enumeration value="0477"/>
			<xs:enumeration value="0531"/>
			<xs:enumeration value="0590"/>
			<xs:enumeration value="0639"/>
			<xs:enumeration value="0647"/>
			<xs:enumeration value="0655"/>
			<xs:enumeration value="0698"/>
			<xs:enumeration value="0728"/>
			<xs:enumeration value="0736"/>
			<xs:enumeration value="0779"/>
			<xs:enumeration value="0809"/>
			<xs:enumeration value="0817"/>
			<xs:enumeration value="0833"/>
			<xs:enumeration value="0850"/>
			<xs:enumeration value="0876"/>
			<xs:enumeration value="0884"/>
			<xs:enumeration value="0906"/>
			<xs:enumeration value="0930"/>
			<xs:enumeration value="0973"/>
			<xs:enumeration value="0981"/>
			<xs:enumeration value="1015"/>
			<xs:enumeration value="1058"/>
			<xs:enumeration value="1082"/>
			<xs:enumeration value="1112"/>
			<xs:enumeration value="1155"/>
			<xs:enumeration value="1198"/>
			<xs:enumeration value="1279"/>
			<xs:enumeration value="1376"/>
			<xs:enumeration value="1414"/>
			<xs:enumeration value="1457"/>
			<xs:enumeration value="1490"/>
			<xs:enumeration value="1504"/>
			<xs:enumeration value="1508"/>
			<xs:enumeration value="1511"/>
			<xs:enumeration value="1538"/>
			<xs:enumeration value="1546"/>
			<xs:enumeration value="1589"/>
			<xs:enumeration value="1600"/>
			<xs:enumeration value="1619"/>
			<xs:enumeration value="1635"/>
			<xs:enumeration value="1651"/>
			<xs:enumeration value="1694"/>
			<xs:enumeration value="1732"/>
			<xs:enumeration value="1775"/>
			<xs:enumeration value="1830"/>
			<xs:enumeration value="1872"/>
			<xs:enumeration value="1902"/>
			<xs:enumeration value="1937"/>
			<xs:enumeration value="1953"/>
			<xs:enumeration value="1961"/>
			<xs:enumeration value="1988"/>
			<xs:enumeration value="1996"/>
			<xs:enumeration value="2291"/>
			<xs:enumeration value="2321"/>
			<xs:enumeration value="2356"/>
			<xs:enumeration value="2399"/>
			<xs:enumeration value="2402"/>
			<xs:enumeration value="2437"/>
			<xs:enumeration value="2445"/>
			<xs:enumeration value="2453"/>
			<xs:enumeration value="2461"/>
			<xs:enumeration value="2470"/>
			<xs:enumeration value="2496"/>
			<xs:enumeration value="2518"/>
			<xs:enumeration value="2534"/>
			<xs:enumeration value="2550"/>
			<xs:enumeration value="2593"/>
			<xs:enumeration value="2674"/>
			<xs:enumeration value="2712"/>
			<xs:enumeration value="2755"/>
			<xs:enumeration value="2810"/>
			<xs:enumeration value="2852"/>
			<xs:enumeration value="2895"/>
			<xs:enumeration value="2917"/>
			<xs:enumeration value="2933"/>
			<xs:enumeration value="2976"/>
			<xs:enumeration value="3018"/>
			<xs:enumeration value="3050"/>
			<xs:enumeration value="3093"/>
			<xs:enumeration value="3131"/>
			<xs:enumeration value="3174"/>
			<xs:enumeration value="3255"/>
			<xs:enumeration value="3298"/>
			<xs:enumeration value="3310"/>
			<xs:enumeration value="3344"/>
			<xs:enumeration value="3379"/>
			<xs:enumeration value="3417"/>
			<xs:enumeration value="3450"/>
			<xs:enumeration value="3514"/>
			<xs:enumeration value="3557"/>
			<xs:enumeration value="3573"/>
			<xs:enumeration value="3595"/>
			<xs:enumeration value="3611"/>
			<xs:enumeration value="3654"/>
			<xs:enumeration value="3697"/>
			<xs:enumeration value="3727"/>
			<xs:enumeration value="3751"/>
			<xs:enumeration value="3794"/>
			<xs:enumeration value="3832"/>
			<xs:enumeration value="3867"/>
			<xs:enumeration value="3913"/>
			<xs:enumeration value="3964"/>
			<xs:enumeration value="3999"/>
			<xs:enumeration value="4030"/>
			<xs:enumeration value="4111"/>
			<xs:enumeration value="4200"/>
			<xs:enumeration value="4235"/>
			<xs:enumeration value="4260"/>
			<xs:enumeration value="4278"/>
			<xs:enumeration value="4316"/>
			<xs:enumeration value="4340"/>
			<xs:enumeration value="4383"/>
			<xs:enumeration value="4405"/>
			<xs:enumeration value="4421"/>
			<xs:enumeration value="4456"/>
			<xs:enumeration value="4472"/>
			<xs:enumeration value="4499"/>
			<xs:enumeration value="4502"/>
			<xs:enumeration value="4525"/>
			<xs:enumeration value="4553"/>
			<xs:enumeration value="4588"/>
			<xs:enumeration value="4618"/>
			<xs:enumeration value="4642"/>
			<xs:enumeration value="4677"/>
			<xs:enumeration value="4723"/>
			<xs:enumeration value="4740"/>
			<xs:enumeration value="4766"/>
			<xs:enumeration value="4774"/>
			<xs:enumeration value="4855"/>
			<xs:enumeration value="4880"/>
			<xs:enumeration value="4885"/>
			<xs:enumeration value="4901"/>
			<xs:enumeration value="4936"/>
			<xs:enumeration value="4944"/>
			<xs:enumeration value="4952"/>
			<xs:enumeration value="4979"/>
			<xs:enumeration value="4985"/>
			<xs:enumeration value="4995"/>
			<xs:enumeration value="5010"/>
			<xs:enumeration value="5053"/>
			<xs:enumeration value="5070"/>
			<xs:enumeration value="5088"/>
			<xs:enumeration value="5118"/>
			<xs:enumeration value="5177"/>
			<xs:enumeration value="5215"/>
			<xs:enumeration value="5258"/>
			<xs:enumeration value="5282"/>
			<xs:enumeration value="5312"/>
			<xs:enumeration value="5355"/>
			<xs:enumeration value="5380"/>
			<xs:enumeration value="5428"/>
			<xs:enumeration value="5452"/>
			<xs:enumeration value="5487"/>
			<xs:enumeration value="5517"/>
			<xs:enumeration value="5568"/>
			<xs:enumeration value="5665"/>
			<xs:enumeration value="5738"/>
			<xs:enumeration value="5754"/>
			<xs:enumeration value="5762"/>
			<xs:enumeration value="5800"/>
			<xs:enumeration value="5860"/>
			<xs:enumeration value="5894"/>
			<xs:enumeration value="5932"/>
			<xs:enumeration value="5991"/>
			<xs:enumeration value="6033"/>
			<xs:enumeration value="6076"/>
			<xs:enumeration value="6114"/>
			<xs:enumeration value="6238"/>
			<xs:enumeration value="6254"/>
			<xs:enumeration value="6289"/>
			<xs:enumeration value="6408"/>
			<xs:enumeration value="6475"/>
			<xs:enumeration value="6602"/>
			<xs:enumeration value="6653"/>
			<xs:enumeration value="6700"/>
			<xs:enumeration value="6750"/>
			<xs:enumeration value="6769"/>
			<xs:enumeration value="6777"/>
			<xs:enumeration value="6781"/>
			<xs:enumeration value="6858"/>
			<xs:enumeration value="6874"/>
			<xs:enumeration value="6904"/>
			<xs:enumeration value="6912"/>
			<xs:enumeration value="6955"/>
			<xs:enumeration value="6971"/>
			<xs:enumeration value="7005"/>
			<xs:enumeration value="7056"/>
			<xs:enumeration value="7102"/>
			<xs:enumeration value="7153"/>
			<xs:enumeration value="7200"/>
			<xs:enumeration value="7285"/>
			<xs:enumeration value="7315"/>
			<xs:enumeration value="7358"/>
			<xs:enumeration value="7370"/>
			<xs:enumeration value="7412"/>
			<xs:enumeration value="7447"/>
			<xs:enumeration value="7480"/>
			<xs:enumeration value="7501"/>
			<xs:enumeration value="7544"/>
			<xs:enumeration value="7560"/>
			<xs:enumeration value="7595"/>
			<xs:enumeration value="7641"/>
			<xs:enumeration value="7676"/>
			<xs:enumeration value="7706"/>
			<xs:enumeration value="7722"/>
			<xs:enumeration value="7765"/>
			<xs:enumeration value="7803"/>
			<xs:enumeration value="7820"/>
			<xs:enumeration value="7838"/>
			<xs:enumeration value="7889"/>
			<xs:enumeration value="7919"/>
			<xs:enumeration value="7951"/>
			<xs:enumeration value="8001"/>
			<xs:enumeration value="8052"/>
			<xs:enumeration value="8109"/>
			<xs:enumeration value="8150"/>
			<xs:enumeration value="8206"/>
			<xs:enumeration value="8230"/>
			<xs:enumeration value="8249"/>
			<xs:enumeration value="8273"/>
			<xs:enumeration value="8281"/>
			<xs:enumeration value="8311"/>
			<xs:enumeration value="8338"/>
			<xs:enumeration value="8451"/>
			<xs:enumeration value="8478"/>
			<xs:enumeration value="8486"/>
			<xs:enumeration value="8508"/>
			<xs:enumeration value="8583"/>
			<xs:enumeration value="8630"/>
			<xs:enumeration value="8664"/>
			<xs:enumeration value="8702"/>
			<xs:enumeration value="8737"/>
			<xs:enumeration value="8885"/>
			<xs:enumeration value="8907"/>
			<xs:enumeration value="8958"/>
			<xs:enumeration value="9903"/>
			<xs:enumeration value="9946"/>
			<xs:enumeration value="9950"/>
			<xs:enumeration value="9970"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TUf">
		<xs:annotation>
			<xs:documentation>Tipo Sigla da UF</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="AC"/>
			<xs:enumeration value="AL"/>
			<xs:enumeration value="AM"/>
			<xs:enumeration value="AP"/>
			<xs:enumeration value="BA"/>
			<xs:enumeration value="CE"/>
			<xs:enumeration value="DF"/>
			<xs:enumeration value="ES"/>
			<xs:enumeration value="GO"/>
			<xs:enumeration value="MA"/>
			<xs:enumeration value="MG"/>
			<xs:enumeration value="MS"/>
			<xs:enumeration value="MT"/>
			<xs:enumeration value="PA"/>
			<xs:enumeration value="PB"/>
			<xs:enumeration value="PE"/>
			<xs:enumeration value="PI"/>
			<xs:enumeration value="PR"/>
			<xs:enumeration value="RJ"/>
			<xs:enumeration value="RN"/>
			<xs:enumeration value="RO"/>
			<xs:enumeration value="RR"/>
			<xs:enumeration value="RS"/>
			<xs:enumeration value="SC"/>
			<xs:enumeration value="SE"/>
			<xs:enumeration value="SP"/>
			<xs:enumeration value="TO"/>
			<xs:enumeration value="EX"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TUfEmi">
		<xs:annotation>
			<xs:documentation>Tipo Sigla da UF de emissor // acrescentado em 24/10/08 </xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="AC"/>
			<xs:enumeration value="AL"/>
			<xs:enumeration value="AM"/>
			<xs:enumeration value="AP"/>
			<xs:enumeration value="BA"/>
			<xs:enumeration value="CE"/>
			<xs:enumeration value="DF"/>
			<xs:enumeration value="ES"/>
			<xs:enumeration value="GO"/>
			<xs:enumeration value="MA"/>
			<xs:enumeration value="MG"/>
			<xs:enumeration value="MS"/>
			<xs:enumeration value="MT"/>
			<xs:enumeration value="PA"/>
			<xs:enumeration value="PB"/>
			<xs:enumeration value="PE"/>
			<xs:enumeration value="PI"/>
			<xs:enumeration value="PR"/>
			<xs:enumeration value="RJ"/>
			<xs:enumeration value="RN"/>
			<xs:enumeration value="RO"/>
			<xs:enumeration value="RR"/>
			<xs:enumeration value="RS"/>
			<xs:enumeration value="SC"/>
			<xs:enumeration value="SE"/>
			<xs:enumeration value="SP"/>
			<xs:enumeration value="TO"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TAmb">
		<xs:annotation>
			<xs:documentation>Tipo Ambiente</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="1"/>
			<xs:enumeration value="2"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TVerAplic">
		<xs:annotation>
			<xs:documentation>Tipo Versão do Aplicativo</xs:documentation>
		</xs:annotation>
		<xs:restriction base="TString">
			<xs:minLength value="1"/>
			<xs:maxLength value="20"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TMotivo">
		<xs:annotation>
			<xs:documentation>Tipo Motivo</xs:documentation>
		</xs:annotation>
		<xs:restriction base="TString">
			<xs:maxLength value="255"/>
			<xs:minLength value="1"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TJust">
		<xs:annotation>
			<xs:documentation>Tipo Justificativa</xs:documentation>
		</xs:annotation>
		<xs:restriction base="TString">
			<xs:minLength value="15"/>
			<xs:maxLength value="255"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TServ">
		<xs:annotation>
			<xs:documentation>Tipo Serviço solicitado</xs:documentation>
		</xs:annotation>
		<xs:restriction base="TString"/>
	</xs:simpleType>
	<xs:simpleType name="Tano">
		<xs:annotation>
			<xs:documentation> Tipo ano</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{2}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TMed">
		<xs:annotation>
			<xs:documentation> Tipo temp médio em segundos</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[0-9]{1,4}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TString">
		<xs:annotation>
			<xs:documentation> Tipo string genérico</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="[!-ÿ]{1}[ -ÿ]{0,}[!-ÿ]{1}|[!-ÿ]{1}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TData">
		<xs:annotation>
			<xs:documentation> Tipo data AAAA-MM-DD</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="(((20(([02468][048])|([13579][26]))-02-29))|(20[0-9][0-9])-((((0[1-9])|(1[0-2]))-((0[1-9])|(1\d)|(2[0-8])))|((((0[13578])|(1[02]))-31)|(((0[1,3-9])|(1[0-2]))-(29|30)))))"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TTime">
		<xs:annotation>
			<xs:documentation> Tipo hora HH:MM:SS // tipo acrescentado na v2.0</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="(([0-1][0-9])|([2][0-3])):([0-5][0-9]):([0-5][0-9])"/>
		</xs:restriction>
	</xs:simpleType>	
	<xs:complexType name="TNFe">
		<xs:annotation>
			<xs:documentation>Tipo Nota Fiscal Eletrônica // v2.0</xs:documentation>
		</xs:annotation>
		<xs:sequence>
			<xs:element name="infNFe">
				<xs:annotation>
					<xs:documentation>Informações da Nota Fiscal eletrônica</xs:documentation>
				</xs:annotation>
				<xs:complexType>
					<xs:sequence>
						<xs:element name="ide">
							<xs:annotation>
								<xs:documentation>identificação da NF-e</xs:documentation>
							</xs:annotation>
							<xs:complexType>
								<xs:sequence>
									<xs:element name="cUF" type="TCodUfIBGE">
										<xs:annotation>
											<xs:documentation>Código da UF do emitente do Documento Fiscal. Utilizar a Tabela do IBGE.</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="cNF">
										<xs:annotation>
											<xs:documentation>Código numérico que compõe a Chave de Acesso. Número aleatório gerado pelo emitente para cada NF-e. (tamanho reduzido para 8 dígitos v2.0)</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="xs:string">
												<xs:whiteSpace value="preserve"/>
												<xs:pattern value="[0-9]{8}"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="natOp">
										<xs:annotation>
											<xs:documentation>Descrição da Natureza da Operação</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:minLength value="1"/>
												<xs:maxLength value="60"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="indPag">
										<xs:annotation>
											<xs:documentation>Indicador da forma de pagamento:
0 – pagamento à vista;
1 – pagamento à prazo;
2 – outros.</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="xs:string">
												<xs:whiteSpace value="preserve"/>
												<xs:enumeration value="0"/>
												<xs:enumeration value="1"/>
												<xs:enumeration value="2"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="mod" type="TMod">
										<xs:annotation>
											<xs:documentation>Código do modelo do Documento Fiscal. Utilizar 55 para identificação da NF-e, emitida em substituição ao modelo 1 e 1A.</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="serie" type="TSerie">
										<xs:annotation>
											<xs:documentation>Série do Documento Fiscal
série normal 0-889
Avulsa Fisco 890-899
SCAN 900-999</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="nNF" type="TNF">
										<xs:annotation>
											<xs:documentation>Número do Documento Fiscal</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="dEmi" type="TData">
										<xs:annotation>
											<xs:documentation>Data de emissão do Documento Fiscal (AAAA-MM-DD)</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:sequence minOccurs="0">
										<xs:annotation>
											<xs:documentation>NT2011/004</xs:documentation>
										</xs:annotation>
										<xs:element name="dSaiEnt" type="TData">
											<xs:annotation>
												<xs:documentation>Data de saída ou de entrada da mercadoria / produto (AAAA-MM-DD)</xs:documentation>
											</xs:annotation>
										</xs:element>
										<xs:element name="hSaiEnt" type="TTime" minOccurs="0">
											<xs:annotation>
												<xs:documentation>Hora de saída ou de entrada da mercadoria / produto (HH:MM:SS) (v2.0)</xs:documentation>
											</xs:annotation>
										</xs:element>
									</xs:sequence>
									<xs:element name="tpNF">
										<xs:annotation>
											<xs:documentation>Tipo do Documento Fiscal (0 - entrada; 1 - saída)</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="xs:string">
												<xs:whiteSpace value="preserve"/>
												<xs:enumeration value="0"/>
												<xs:enumeration value="1"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="cMunFG" type="TCodMunIBGE">
										<xs:annotation>
											<xs:documentation>Código do Município de Ocorrência do Fato Gerador (utilizar a tabela do IBGE)</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="NFref" minOccurs="0" maxOccurs="500">
										<xs:annotation>
											<xs:documentation>Grupo de infromações da NF referenciada</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:choice>
												<xs:element name="refNFe" type="TChNFe">
													<xs:annotation>
														<xs:documentation>Chave de acesso das NF-e referenciadas. Chave de acesso compostas por Código da UF (tabela do IBGE) + AAMM da emissão + CNPJ do Emitente + modelo, série e número da NF-e Referenciada + Código Numérico + DV.</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="refNF">
													<xs:annotation>
														<xs:documentation>Dados da NF modelo 1/1A referenciada</xs:documentation>
													</xs:annotation>
													<xs:complexType>
														<xs:sequence>
															<xs:element name="cUF" type="TCodUfIBGE">
																<xs:annotation>
																	<xs:documentation>Código da UF do emitente do Documento Fiscal. Utilizar a Tabela do IBGE.</xs:documentation>
																</xs:annotation>
															</xs:element>
															<xs:element name="AAMM">
																<xs:annotation>
																	<xs:documentation>AAMM da emissão</xs:documentation>
																</xs:annotation>
																<xs:simpleType>
																	<xs:restriction base="xs:string">
																		<xs:whiteSpace value="preserve"/>
																		<xs:pattern value="[0-9]{2}[0]{1}[1-9]{1}|[0-9]{2}[1]{1}[0-2]{1}"/>
																	</xs:restriction>
																</xs:simpleType>
															</xs:element>
															<xs:element name="CNPJ" type="TCnpj">
																<xs:annotation>
																	<xs:documentation>CNPJ do emitente do documento fiscal referenciado</xs:documentation>
																</xs:annotation>
															</xs:element>
															<xs:element name="mod">
																<xs:annotation>
																	<xs:documentation>Código do modelo do Documento Fiscal. Utilizar 01 para NF modelo 1/1A</xs:documentation>
																</xs:annotation>
																<xs:simpleType>
																	<xs:restriction base="xs:string">
																		<xs:whiteSpace value="preserve"/>
																		<xs:enumeration value="01"/>
																	</xs:restriction>
																</xs:simpleType>
															</xs:element>
															<xs:element name="serie" type="TSerie">
																<xs:annotation>
																	<xs:documentation>Série do Documento Fiscal, informar zero se inexistente</xs:documentation>
																</xs:annotation>
															</xs:element>
															<xs:element name="nNF" type="TNF">
																<xs:annotation>
																	<xs:documentation>Número do Documento Fiscal</xs:documentation>
																</xs:annotation>
															</xs:element>
														</xs:sequence>
													</xs:complexType>
												</xs:element>
												<xs:element name="refNFP">
													<xs:annotation>
														<xs:documentation>Grupo com as informações NF de produtor referenciada (v2.0)</xs:documentation>
													</xs:annotation>
													<xs:complexType>
														<xs:sequence>
															<xs:element name="cUF" type="TCodUfIBGE">
																<xs:annotation>
																	<xs:documentation>Código da UF do emitente do Documento FiscalUtilizar a Tabela do IBGE (Anexo IV - Tabela de UF, Município e País) (v2.0)</xs:documentation>
																</xs:annotation>
															</xs:element>
															<xs:element name="AAMM">
																<xs:annotation>
																	<xs:documentation>AAMM da emissão da NF de produtor (v2.0)</xs:documentation>
																</xs:annotation>
																<xs:simpleType>
																	<xs:restriction base="xs:string">
																		<xs:whiteSpace value="preserve"/>
																		<xs:pattern value="[0-9]{2}[0]{1}[1-9]{1}|[0-9]{2}[1]{1}[0-2]{1}"/>
																	</xs:restriction>
																</xs:simpleType>
															</xs:element>
															<xs:choice>
																<xs:element name="CNPJ" type="TCnpj">
																	<xs:annotation>
																		<xs:documentation>CNPJ do emitente da NF de produtor (v2.0)</xs:documentation>
																	</xs:annotation>
																</xs:element>
																<xs:element name="CPF" type="TCpf">
																	<xs:annotation>
																		<xs:documentation>CPF do emitente da NF de produtor (v2.0)</xs:documentation>
																	</xs:annotation>
																</xs:element>
															</xs:choice>
															<xs:element name="IE" type="TIeDest">
																<xs:annotation>
																	<xs:documentation>IE do emitente da NF de Produtor (v2.0))</xs:documentation>
																</xs:annotation>
															</xs:element>
															<xs:element name="mod">
																<xs:annotation>
																	<xs:documentation>Código do modelo do Documento Fiscal - utilizar 04 para NF de produtor  ou 01 para NF Avulsa(v2.0)</xs:documentation>
																</xs:annotation>
																<xs:simpleType>
																	<xs:restriction base="xs:string">
																		<xs:whiteSpace value="preserve"/>
																		<xs:enumeration value="01"/>
																		<xs:enumeration value="04"/>
																	</xs:restriction>
																</xs:simpleType>
															</xs:element>
															<xs:element name="serie" type="TSerie">
																<xs:annotation>
																	<xs:documentation>Série do Documento Fiscal, informar zero se inexistentesérie (v2.0).</xs:documentation>
																</xs:annotation>
															</xs:element>
															<xs:element name="nNF" type="TNF">
																<xs:annotation>
																	<xs:documentation>Número do Documento Fiscal - 1 – 999999999 - (v2.0)</xs:documentation>
																</xs:annotation>
															</xs:element>
														</xs:sequence>
													</xs:complexType>
												</xs:element>
												<xs:element name="refCTe" type="TChNFe">
													<xs:annotation>
														<xs:documentation>Utilizar esta TAG para referenciar um CT-e emitido anteriormente, vinculada a NF-e atual - (v2.0).</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="refECF">
													<xs:annotation>
														<xs:documentation>Grupo do Cupom Fiscal vinculado à NF-e (v2.0).</xs:documentation>
													</xs:annotation>
													<xs:complexType>
														<xs:sequence>
															<xs:element name="mod">
																<xs:annotation>
																	<xs:documentation>Código do modelo do Documento Fiscal 
Preencher com "2B", quando se tratar de Cupom Fiscal emitido por máquina registradora (não ECF), com "2C", quando se tratar de Cupom Fiscal PDV, ou "2D", quando se tratar de Cupom Fiscal (emitido por ECF) (v2.0).</xs:documentation>
																</xs:annotation>
																<xs:simpleType>
																	<xs:restriction base="xs:string">
																		<xs:whiteSpace value="preserve"/>
																		<xs:enumeration value="2B"/>
																		<xs:enumeration value="2C"/>
																		<xs:enumeration value="2D"/>
																	</xs:restriction>
																</xs:simpleType>
															</xs:element>
															<xs:element name="nECF">
																<xs:annotation>
																	<xs:documentation>Informar o número de ordem seqüencial do ECF que emitiu o Cupom Fiscal vinculado à NF-e (v2.0).</xs:documentation>
																</xs:annotation>
																<xs:simpleType>
																	<xs:restriction base="xs:string">
																		<xs:whiteSpace value="preserve"/>
																		<xs:pattern value="[0-9]{1,3}"/>
																	</xs:restriction>
																</xs:simpleType>
															</xs:element>
															<xs:element name="nCOO">
																<xs:annotation>
																	<xs:documentation>Informar o Número do Contador de Ordem de Operação - COO vinculado à NF-e (v2.0).</xs:documentation>
																</xs:annotation>
																<xs:simpleType>
																	<xs:restriction base="xs:string">
																		<xs:whiteSpace value="preserve"/>
																		<xs:pattern value="[0-9]{1,6}"/>
																	</xs:restriction>
																</xs:simpleType>
															</xs:element>
														</xs:sequence>
													</xs:complexType>
												</xs:element>
											</xs:choice>
										</xs:complexType>
									</xs:element>
									<xs:element name="tpImp">
										<xs:annotation>
											<xs:documentation>Formato de impressão do DANFE (1 - Retrato; 2 - Paisagem)</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="xs:string">
												<xs:whiteSpace value="preserve"/>
												<xs:enumeration value="1"/>
												<xs:enumeration value="2"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="tpEmis">
										<xs:annotation>
											<xs:documentation>Forma de emissão da NF-e
1 - Normal;
2 - Contingência FS
3 - Contingência SCAN
4 - Contingência DPEC
5 - Contingência FSDA
6 - Contingência SVC - AN
7 - Contingência SVC - RS</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="xs:string">
												<xs:whiteSpace value="preserve"/>
												<xs:enumeration value="1"/>
												<xs:enumeration value="2"/>
												<xs:enumeration value="3"/>
												<xs:enumeration value="4"/>
												<xs:enumeration value="5"/>
												<xs:enumeration value="6"/>
												<xs:enumeration value="7"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="cDV">
										<xs:annotation>
											<xs:documentation>Digito Verificador da Chave de Acesso da NF-e</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="xs:string">
												<xs:whiteSpace value="preserve"/>
												<xs:pattern value="[0-9]{1}"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="tpAmb" type="TAmb">
										<xs:annotation>
											<xs:documentation>Identificação do Ambiente:
1 - Produção
2 - Homologação</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="finNFe" type="TFinNFe">
										<xs:annotation>
											<xs:documentation>Finalidade da emissão da NF-e:
1 - NFe normal
2 - NFe complementar
3 - NFe de ajuste</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="procEmi" type="TProcEmi">
										<xs:annotation>
											<xs:documentation>Processo de emissão utilizado com a seguinte codificação:
0 - emissão de NF-e com aplicativo do contribuinte;
1 - emissão de NF-e avulsa pelo Fisco;
2 - emissão de NF-e avulsa, pelo contribuinte com seu certificado digital, através do site
do Fisco;
3- emissão de NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="verProc">
										<xs:annotation>
											<xs:documentation>versão do aplicativo utilizado no processo de
emissão</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:minLength value="1"/>
												<xs:maxLength value="20"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:sequence minOccurs="0">
										<xs:annotation>
											<xs:documentation>Informar apenas
para tpEmis diferente de 1</xs:documentation>
										</xs:annotation>
										<xs:element name="dhCont">
											<xs:annotation>
												<xs:documentation>Informar a data e hora de entrada em contingência contingência no formato AAAA-MM-DDTHH:MM:SS (v.2.0).</xs:documentation>
											</xs:annotation>
											<xs:simpleType>
												<xs:restriction base="xs:string">
													<xs:whiteSpace value="preserve"/>
													<xs:pattern value="(((20(([02468][048])|([13579][26]))-02-29))|(20[0-9][0-9])-((((0[1-9])|(1[0-2]))-((0[1-9])|(1\d)|(2[0-8])))|((((0[13578])|(1[02]))-31)|(((0[1,3-9])|(1[0-2]))-(29|30)))))T(20|21|22|23|[0-1]\d):[0-5]\d:[0-5]\d"/>
												</xs:restriction>
											</xs:simpleType>
										</xs:element>
										<xs:element name="xJust">
											<xs:annotation>
												<xs:documentation>Informar a Justificativa da entrada em (v.2.0)</xs:documentation>
											</xs:annotation>
											<xs:simpleType>
												<xs:restriction base="TString">
													<xs:minLength value="15"/>
													<xs:maxLength value="256"/>
												</xs:restriction>
											</xs:simpleType>
										</xs:element>
									</xs:sequence>
								</xs:sequence>
							</xs:complexType>
						</xs:element>
						<xs:element name="emit">
							<xs:annotation>
								<xs:documentation>Identificação do emitente</xs:documentation>
							</xs:annotation>
							<xs:complexType>
								<xs:sequence>
									<xs:choice>
										<xs:element name="CNPJ" type="TCnpj">
											<xs:annotation>
												<xs:documentation>Número do CNPJ do emitente</xs:documentation>
											</xs:annotation>
										</xs:element>
										<xs:element name="CPF" type="TCpf">
											<xs:annotation>
												<xs:documentation>Número do CPF do emitente</xs:documentation>
											</xs:annotation>
										</xs:element>
									</xs:choice>
									<xs:element name="xNome">
										<xs:annotation>
											<xs:documentation>Razão Social ou Nome do emitente</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:maxLength value="60"/>
												<xs:minLength value="2"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="xFant" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Nome fantasia</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:maxLength value="60"/>
												<xs:minLength value="1"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="enderEmit" type="TEnderEmi">
										<xs:annotation>
											<xs:documentation>Endereço do emitente</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="IE" type="TIe">
										<xs:annotation>
											<xs:documentation>Inscrição Estadual</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="IEST" type="TIeST" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Inscricao Estadual do Substituto Tributário</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:sequence minOccurs="0">
										<xs:annotation>
											<xs:documentation>Grupo de informações de interesse da Prefeitura</xs:documentation>
										</xs:annotation>
										<xs:element name="IM">
											<xs:annotation>
												<xs:documentation>Inscrição Municipal</xs:documentation>
											</xs:annotation>
											<xs:simpleType>
												<xs:restriction base="TString">
													<xs:minLength value="1"/>
													<xs:maxLength value="15"/>
												</xs:restriction>
											</xs:simpleType>
										</xs:element>
										<xs:element name="CNAE">
											<xs:annotation>
												<xs:documentation>CNAE Fiscal</xs:documentation>
											</xs:annotation>
											<xs:simpleType>
												<xs:restriction base="xs:string">
													<xs:whiteSpace value="preserve"/>
													<xs:pattern value="[0-9]{7}"/>
												</xs:restriction>
											</xs:simpleType>
										</xs:element>
									</xs:sequence>
									<xs:element name="CRT">
										<xs:annotation>
											<xs:documentation>Código de Regime Tributário. 
Este campo será obrigatoriamente preenchido com:
1 – Simples Nacional;
2 – Simples Nacional – excesso de sublimite de receita bruta;
3 – Regime Normal. (v2.0).
</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="xs:string">
												<xs:whiteSpace value="preserve"/>
												<xs:enumeration value="1"/>
												<xs:enumeration value="2"/>
												<xs:enumeration value="3"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
								</xs:sequence>
							</xs:complexType>
						</xs:element>
						<xs:element name="avulsa" minOccurs="0">
							<xs:annotation>
								<xs:documentation>Emissão de avulsa, informar os dados do Fisco emitente</xs:documentation>
							</xs:annotation>
							<xs:complexType>
								<xs:sequence>
									<xs:element name="CNPJ" type="TCnpj">
										<xs:annotation>
											<xs:documentation>CNPJ do Órgão emissor</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="xOrgao">
										<xs:annotation>
											<xs:documentation>Órgão emitente</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:maxLength value="60"/>
												<xs:minLength value="1"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="matr">
										<xs:annotation>
											<xs:documentation>Matrícula do agente</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:minLength value="1"/>
												<xs:maxLength value="60"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="xAgente">
										<xs:annotation>
											<xs:documentation>Nome do agente</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:maxLength value="60"/>
												<xs:minLength value="1"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="fone" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Telefone</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="xs:string">
												<xs:whiteSpace value="preserve"/>
												<xs:pattern value="[0-9]{1,11}"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="UF" type="TUfEmi">
										<xs:annotation>
											<xs:documentation>Sigla da Unidade da Federação</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="nDAR" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Número do Documento de Arrecadação de Receita</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:minLength value="1"/>
												<xs:maxLength value="60"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="dEmi" type="TData" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Data de emissão do DAR (AAAA-MM-DD)</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="vDAR" type="TDec_1302" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Valor Total constante no DAR</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="repEmi">
										<xs:annotation>
											<xs:documentation>Repartição Fiscal emitente</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:minLength value="1"/>
												<xs:maxLength value="60"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="dPag" type="TData" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Data de pagamento do DAR (AAAA-MM-DD)</xs:documentation>
										</xs:annotation>
									</xs:element>
								</xs:sequence>
							</xs:complexType>
						</xs:element>
						<xs:element name="dest">
							<xs:annotation>
								<xs:documentation>Identificação do Destinatário  </xs:documentation>
							</xs:annotation>
							<xs:complexType>
								<xs:sequence>
									<xs:choice>
										<xs:element name="CNPJ" type="TCnpjOpc">
											<xs:annotation>
												<xs:documentation>Número do CNPJ</xs:documentation>
											</xs:annotation>
										</xs:element>
										<xs:element name="CPF" type="TCpf">
											<xs:annotation>
												<xs:documentation>Número do CPF</xs:documentation>
											</xs:annotation>
										</xs:element>
									</xs:choice>
									<xs:element name="xNome">
										<xs:annotation>
											<xs:documentation>Razão Social ou nome do destinatário</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:maxLength value="60"/>
												<xs:minLength value="2"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="enderDest" type="TEndereco">
										<xs:annotation>
											<xs:documentation>Dados do endereço</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="IE" type="TIeDest">
										<xs:annotation>
											<xs:documentation>Inscrição Estadual (obrigatório nas operações com contribuintes do ICMS)</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="ISUF" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Inscrição na SUFRAMA (Obrigatório nas operações com as áreas com benefícios de incentivos fiscais sob controle da SUFRAMA) PL_005d - 11/08/09 - alterado para aceitar 8 ou 9 dígitos</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="xs:string">
												<xs:whiteSpace value="preserve"/>
												<xs:pattern value="[0-9]{8,9}"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="email" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Informar o e-mail do destinatário. O campo pode ser utilizado para informar o e-mail
de recepção da NF-e indicada pelo destinatário (v2.0)</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:minLength value="1"/>
												<xs:maxLength value="60"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
								</xs:sequence>
							</xs:complexType>
						</xs:element>
						<xs:element name="retirada" type="TLocal" minOccurs="0">
							<xs:annotation>
								<xs:documentation>Identificação do Local de Retirada (informar apenas quando for diferente do endereço do remetente)</xs:documentation>
							</xs:annotation>
						</xs:element>
						<xs:element name="entrega" type="TLocal" minOccurs="0">
							<xs:annotation>
								<xs:documentation>Identificação do Local de Entrega (informar apenas quando for diferente do endereço do destinatário)</xs:documentation>
							</xs:annotation>
						</xs:element>
						<xs:element name="det" maxOccurs="990">
							<xs:annotation>
								<xs:documentation>Dados dos detalhes da NF-e</xs:documentation>
							</xs:annotation>
							<xs:complexType>
								<xs:sequence>
									<xs:element name="prod">
										<xs:annotation>
											<xs:documentation>Dados dos produtos e serviços da NF-e</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="cProd">
													<xs:annotation>
														<xs:documentation>Código do produto ou serviço. Preencher com CFOP caso se trate de itens não relacionados com mercadorias/produto e que o contribuinte não possua codificação própria
Formato ”CFOP9999”.</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:maxLength value="60"/>
															<xs:minLength value="1"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="cEAN">
													<xs:annotation>
														<xs:documentation>GTIN (Global Trade Item Number) do produto, antigo código EAN ou código de barras</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="xs:string">
															<xs:whiteSpace value="preserve"/>
															<xs:pattern value="[0-9]{0}|[0-9]{8}|[0-9]{12,14}"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="xProd">
													<xs:annotation>
														<xs:documentation>Descrição do produto ou serviço</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:maxLength value="120"/>
															<xs:minLength value="1"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="NCM">
													<xs:annotation>
														<xs:documentation>Código NCM (8 posições), será permitida a informação do gênero (posição do capítulo do NCM) quando a operação não for de comércio exterior (importação/exportação) ou o produto não seja tributado pelo IPI. Em caso de item de serviço ou item que não tenham produto (Ex. transferência de crédito, crédito do ativo imobilizado, etc.), informar o código 00 (zeros) (v2.0)</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="xs:string">
															<xs:whiteSpace value="preserve"/>
															<xs:pattern value="[0-9]{2}|[0][1-9][0-9]{6}|[1-9][0-9]{7}"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="EXTIPI" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Código EX TIPI (3 posições)</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="xs:string">
															<xs:whiteSpace value="preserve"/>
															<xs:pattern value="[0-9]{2,3}"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="CFOP" type="TCfop">
													<xs:annotation>
														<xs:documentation>Código Fiscal de Operações e Prestações</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="uCom">
													<xs:annotation>
														<xs:documentation>Unidade comercial</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:maxLength value="6"/>
															<xs:minLength value="1"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="qCom" type="TDec_1104v">
													<xs:annotation>
														<xs:documentation>Quantidade Comercial  do produto, alterado para aceitar de 0 a 4 casas decimais e 11 inteiros. (v2.0)</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vUnCom" type="TDec_1110">
													<xs:annotation>
														<xs:documentation>Valor unitário de comercialização  - alterado para aceitar 0 a 10 casas decimais e 11 inteiros (v2.0)</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vProd" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor bruto do produto ou serviço.</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="cEANTrib">
													<xs:annotation>
														<xs:documentation>GTIN (Global Trade Item Number) da unidade tributável, antigo código EAN ou código de barras</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="xs:string">
															<xs:whiteSpace value="preserve"/>
															<xs:pattern value="[0-9]{0}|[0-9]{8}|[0-9]{12,14}"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="uTrib">
													<xs:annotation>
														<xs:documentation>Unidade Tributável</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:maxLength value="6"/>
															<xs:minLength value="1"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="qTrib" type="TDec_1104v">
													<xs:annotation>
														<xs:documentation>Quantidade Tributável - alterado para aceitar de 0 a 4 casas decimais e 11 inteiros (v2.0)</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vUnTrib" type="TDec_1110">
													<xs:annotation>
														<xs:documentation>Valor unitário de tributação - - alterado para aceitar 0 a 10 casas decimais e 11 inteiros (v2.0)</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vFrete" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor Total do Frete</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vSeg" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor Total do Seguro</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vDesc" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor do Desconto</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vOutro" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Outras despesas acessórias - (v2.0)</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="indTot">
													<xs:annotation>
														<xs:documentation>Este campo deverá ser preenchido com:
 0 – o valor do item (vProd) não compõe o valor total da NF-e (vProd)
 1  – o valor do item (vProd) compõe o valor total da NF-e (vProd)
(v2.0)
</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="xs:string">
															<xs:whiteSpace value="preserve"/>
															<xs:enumeration value="0"/>
															<xs:enumeration value="1"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="DI" minOccurs="0" maxOccurs="100">
													<xs:annotation>
														<xs:documentation>Delcaração de Importação
(NT 2011/004)</xs:documentation>
													</xs:annotation>
													<xs:complexType>
														<xs:sequence>
															<xs:element name="nDI">
																<xs:annotation>
																	<xs:documentation>Numero do Documento de Importação DI/DSI/DA/DRI-E (DI/DSI/DA/DRI-E) (NT2011/004)</xs:documentation>
																</xs:annotation>
																<xs:simpleType>
																	<xs:restriction base="TString">
																		<xs:minLength value="1"/>
																		<xs:maxLength value="12"/>
																	</xs:restriction>
																</xs:simpleType>
															</xs:element>
															<xs:element name="dDI" type="TData">
																<xs:annotation>
																	<xs:documentation>Data de registro da DI/DSI/DA (AAAA-MM-DD)</xs:documentation>
																</xs:annotation>
															</xs:element>
															<xs:element name="xLocDesemb">
																<xs:annotation>
																	<xs:documentation>Local do desembaraço aduaneiro</xs:documentation>
																</xs:annotation>
																<xs:simpleType>
																	<xs:restriction base="TString">
																		<xs:minLength value="1"/>
																		<xs:maxLength value="60"/>
																	</xs:restriction>
																</xs:simpleType>
															</xs:element>
															<xs:element name="UFDesemb" type="TUfEmi">
																<xs:annotation>
																	<xs:documentation>UF onde ocorreu o desembaraço aduaneiro</xs:documentation>
																</xs:annotation>
															</xs:element>
															<xs:element name="dDesemb" type="TData">
																<xs:annotation>
																	<xs:documentation>Data do desembaraço aduaneiro (AAAA-MM-DD)</xs:documentation>
																</xs:annotation>
															</xs:element>
															<xs:element name="cExportador">
																<xs:annotation>
																	<xs:documentation>Código do exportador (usado nos sistemas internos de informação do emitente da NF-e)</xs:documentation>
																</xs:annotation>
																<xs:simpleType>
																	<xs:restriction base="TString">
																		<xs:minLength value="1"/>
																		<xs:maxLength value="60"/>
																	</xs:restriction>
																</xs:simpleType>
															</xs:element>
															<xs:element name="adi" maxOccurs="100">
																<xs:annotation>
																	<xs:documentation>Adições (NT 2011/004)</xs:documentation>
																</xs:annotation>
																<xs:complexType>
																	<xs:sequence>
																		<xs:element name="nAdicao">
																			<xs:annotation>
																				<xs:documentation>Número da Adição</xs:documentation>
																			</xs:annotation>
																			<xs:simpleType>
																				<xs:restriction base="xs:string">
																					<xs:whiteSpace value="preserve"/>
																					<xs:pattern value="[1-9]{1}[0-9]{0,2}"/>
																				</xs:restriction>
																			</xs:simpleType>
																		</xs:element>
																		<xs:element name="nSeqAdic">
																			<xs:annotation>
																				<xs:documentation>Número seqüencial do item dentro da Adição</xs:documentation>
																			</xs:annotation>
																			<xs:simpleType>
																				<xs:restriction base="xs:string">
																					<xs:whiteSpace value="preserve"/>
																					<xs:pattern value="[1-9]{1}[0-9]{0,2}"/>
																				</xs:restriction>
																			</xs:simpleType>
																		</xs:element>
																		<xs:element name="cFabricante">
																			<xs:annotation>
																				<xs:documentation>Código do fabricante estrangeiro (usado nos sistemas internos de informação do emitente da NF-e)</xs:documentation>
																			</xs:annotation>
																			<xs:simpleType>
																				<xs:restriction base="TString">
																					<xs:minLength value="1"/>
																					<xs:maxLength value="60"/>
																				</xs:restriction>
																			</xs:simpleType>
																		</xs:element>
																		<xs:element name="vDescDI" type="TDec_1302Opc" minOccurs="0">
																			<xs:annotation>
																				<xs:documentation>Valor do desconto do item da DI – adição</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																	</xs:sequence>
																</xs:complexType>
															</xs:element>
														</xs:sequence>
													</xs:complexType>
												</xs:element>
												<xs:element name="xPed" minOccurs="0">
													<xs:annotation>
														<xs:documentation>pedido de compra - Informação de interesse do emissor para controle do B2B. (v2.0)</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:minLength value="1"/>
															<xs:maxLength value="15"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="nItemPed" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Número do Item do Pedido de Compra - Identificação do número do item do pedido de Compra (v2.0)</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="xs:string">
															<xs:whiteSpace value="preserve"/>
															<xs:pattern value="[0-9]{1,6}"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:choice minOccurs="0">
													<xs:annotation>
														<xs:documentation>Informações específicas de produtos e serviços</xs:documentation>
													</xs:annotation>
													<xs:element name="veicProd">
														<xs:annotation>
															<xs:documentation>Veículos novos</xs:documentation>
														</xs:annotation>
														<xs:complexType>
															<xs:sequence>
																<xs:element name="tpOp">
																	<xs:annotation>
																		<xs:documentation>Tipo da Operação (1 - Venda concessionária; 2 - Faturamento direto; 3 - Venda direta; 0 - Outros)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:whiteSpace value="preserve"/>
																			<xs:enumeration value="0"/>
																			<xs:enumeration value="1"/>
																			<xs:enumeration value="2"/>
																			<xs:enumeration value="3"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="chassi">
																	<xs:annotation>
																		<xs:documentation>Chassi do veículo - VIN (código-identificação-veículo)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:length value="17"/>
																			<xs:whiteSpace value="preserve"/>
																			<xs:pattern value="[A-Z0-9]+"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="cCor">
																	<xs:annotation>
																		<xs:documentation>Cor do veículo (código de cada montadora)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="4"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="xCor">
																	<xs:annotation>
																		<xs:documentation>Descrição da cor</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="40"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="pot">
																	<xs:annotation>
																		<xs:documentation>Potência máxima do motor do veículo em cavalo vapor (CV). (potência-veículo)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="4"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="cilin">
																	<xs:annotation>
																		<xs:documentation>Capacidade voluntária do motor expressa em centímetros cúbicos (CC). (cilindradas) (v2.0)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="4"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="pesoL">
																	<xs:annotation>
																		<xs:documentation>Peso líquido</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="9"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="pesoB">
																	<xs:annotation>
																		<xs:documentation>Peso bruto</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="9"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="nSerie">
																	<xs:annotation>
																		<xs:documentation>Serial (série)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="9"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="tpComb">
																	<xs:annotation>
																		<xs:documentation>Tipo de combustível - Utilizar Tabela RENAVAM (v2.0)
01-Álcool
02-Gasolina
03-Diesel
(...)
16-Álcool/Gasolina
17-Gasolina/Álcool/GNV
18-Gasolina/Elétrico
</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="2"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="nMotor">
																	<xs:annotation>
																		<xs:documentation>Número do motor</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="21"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="CMT">
																	<xs:annotation>
																		<xs:documentation>CMT-Capacidade Máxima de Tração - em Toneladas 4 casas decimais (v2.0)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="9"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="dist">
																	<xs:annotation>
																		<xs:documentation>Distância entre eixos</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="4"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="anoMod">
																	<xs:annotation>
																		<xs:documentation>Ano Modelo de Fabricação</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:whiteSpace value="preserve"/>
																			<xs:pattern value="[0-9]{4}"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="anoFab">
																	<xs:annotation>
																		<xs:documentation>Ano de Fabricação</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:whiteSpace value="preserve"/>
																			<xs:pattern value="[0-9]{4}"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="tpPint">
																	<xs:annotation>
																		<xs:documentation>Tipo de pintura</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:length value="1"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="tpVeic">
																	<xs:annotation>
																		<xs:documentation>Tipo de veículo (utilizar tabela RENAVAM)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:whiteSpace value="preserve"/>
																			<xs:pattern value="[0-9]{1,2}"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="espVeic">
																	<xs:annotation>
																		<xs:documentation>Espécie de veículo (utilizar tabela RENAVAM)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:whiteSpace value="preserve"/>
																			<xs:pattern value="[0-9]{1}"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="VIN">
																	<xs:annotation>
																		<xs:documentation>Informa-se o veículo tem VIN (chassi) remarcado.
R-Remarcado
N-NormalVIN </xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:length value="1"/>
																			<xs:enumeration value="R"/>
																			<xs:enumeration value="N"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="condVeic">
																	<xs:annotation>
																		<xs:documentation>Condição do veículo (1 - acabado; 2 - inacabado; 3 - semi-acabado)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:whiteSpace value="preserve"/>
																			<xs:enumeration value="1"/>
																			<xs:enumeration value="2"/>
																			<xs:enumeration value="3"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="cMod">
																	<xs:annotation>
																		<xs:documentation>Código Marca Modelo (utilizar tabela RENAVAM)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:whiteSpace value="preserve"/>
																			<xs:pattern value="[0-9]{1,6}"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="cCorDENATRAN">
																	<xs:annotation>
																		<xs:documentation>Código da Cor Segundo as regras de pré-cadastro do DENATRAN (v2.0)
01-AMARELO 
02-AZUL 
03-BEGE 
04-BRANCA 
05-CINZA 
06-DOURADA 
07-GRENA 
08-LARANJA 
09-MARROM 
10-PRATA 
11-PRETA 
12-ROSA 
13-ROXA 
14-VERDE 
15-VERMELHA 
16-FANTASIA
</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:whiteSpace value="preserve"/>
																			<xs:minLength value="1"/>
																			<xs:maxLength value="2"/>
																			<xs:pattern value="[0-9]{1,2}"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="lota">
																	<xs:annotation>
																		<xs:documentation>Quantidade máxima de permitida de passageiros sentados, inclusive motorista. (v2.0)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="3"/>
																			<xs:whiteSpace value="preserve"/>
																			<xs:pattern value="[0-9]{1,3}"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="tpRest">
																	<xs:annotation>
																		<xs:documentation>Restrição
0 - Não há;
1 - Alienação Fiduciária;
2 - Arrendamento Mercantil;
3 - Reserva de Domínio;
4 - Penhor de Veículos;
9 - outras. (v2.0)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:whiteSpace value="preserve"/>
																			<xs:enumeration value="0"/>
																			<xs:enumeration value="1"/>
																			<xs:enumeration value="2"/>
																			<xs:enumeration value="3"/>
																			<xs:enumeration value="4"/>
																			<xs:enumeration value="9"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
															</xs:sequence>
														</xs:complexType>
													</xs:element>
													<xs:element name="med" maxOccurs="unbounded">
														<xs:annotation>
															<xs:documentation>grupo do detalhamento de Medicamentos e de matérias-primas farmacêuticas</xs:documentation>
														</xs:annotation>
														<xs:complexType>
															<xs:sequence>
																<xs:element name="nLote">
																	<xs:annotation>
																		<xs:documentation>Número do lote do medicamento</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="20"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="qLote" type="TDec_0803">
																	<xs:annotation>
																		<xs:documentation>Quantidade de produtos no lote</xs:documentation>
																	</xs:annotation>
																</xs:element>
																<xs:element name="dFab" type="TData">
																	<xs:annotation>
																		<xs:documentation>Data de Fabricação do medicamento (AAAA-MM-DD)</xs:documentation>
																	</xs:annotation>
																</xs:element>
																<xs:element name="dVal" type="TData">
																	<xs:annotation>
																		<xs:documentation>Data de validade do medicamento (AAAA-MM-DD)</xs:documentation>
																	</xs:annotation>
																</xs:element>
																<xs:element name="vPMC" type="TDec_1302">
																	<xs:annotation>
																		<xs:documentation>Preço Máximo ao Consumidor</xs:documentation>
																	</xs:annotation>
																</xs:element>
															</xs:sequence>
														</xs:complexType>
													</xs:element>
													<xs:element name="arma" maxOccurs="unbounded">
														<xs:annotation>
															<xs:documentation>Armamentos</xs:documentation>
														</xs:annotation>
														<xs:complexType>
															<xs:sequence>
																<xs:element name="tpArma">
																	<xs:annotation>
																		<xs:documentation>Indicador do tipo de arma de fogo (0 - Uso permitido; 1 - Uso restrito)</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:whiteSpace value="preserve"/>
																			<xs:enumeration value="0"/>
																			<xs:enumeration value="1"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="nSerie">
																	<xs:annotation>
																		<xs:documentation>Número de série da arma</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="9"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="nCano">
																	<xs:annotation>
																		<xs:documentation>Número de série do cano</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="9"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="descr">
																	<xs:annotation>
																		<xs:documentation>Descrição completa da arma, compreendendo: calibre, marca, capacidade, tipo de funcionamento, comprimento e demais elementos que permitam a sua perfeita identificação.</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="TString">
																			<xs:minLength value="1"/>
																			<xs:maxLength value="256"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
															</xs:sequence>
														</xs:complexType>
													</xs:element>
													<xs:element name="comb">
														<xs:annotation>
															<xs:documentation>Informar apenas para operações com combustíveis líquidos</xs:documentation>
														</xs:annotation>
														<xs:complexType>
															<xs:sequence>
																<xs:element name="cProdANP" type="TcProdANP">
																	<xs:annotation>
																		<xs:documentation>Código de produto da ANP. codificação de produtos do SIMP (http://www.anp.gov.br)</xs:documentation>
																	</xs:annotation>
																</xs:element>
																<xs:element name="CODIF" minOccurs="0">
																	<xs:annotation>
																		<xs:documentation>Código de autorização / registro
do CODIF.
Informar apenas quando a UF
utilizar o CODIF (Sistema de
Controle do Diferimento do Imposto
nas Operações com AEAC - Álcool
Etílico Anidro Combustível).</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:whiteSpace value="preserve"/>
																			<xs:pattern value="[0-9]{0,21}"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
																<xs:element name="qTemp" type="TDec_1204Opc" minOccurs="0">
																	<xs:annotation>
																		<xs:documentation>Quantidade de combustível
faturada à temperatura ambiente.
Informar quando a quantidade
faturada informada no campo
qCom (I10) tiver sido ajustada para
uma temperatura diferente da
ambiente.</xs:documentation>
																	</xs:annotation>
																</xs:element>
																<xs:element name="UFCons" type="TUf">
																	<xs:annotation>
																		<xs:documentation>Sigla da UF de Consumo</xs:documentation>
																	</xs:annotation>
																</xs:element>
																<xs:element name="CIDE" minOccurs="0">
																	<xs:annotation>
																		<xs:documentation>CIDE Combustíveis</xs:documentation>
																	</xs:annotation>
																	<xs:complexType>
																		<xs:sequence>
																			<xs:element name="qBCProd" type="TDec_1204">
																				<xs:annotation>
																					<xs:documentation>BC do CIDE ( Quantidade comercializada) </xs:documentation>
																				</xs:annotation>
																			</xs:element>
																			<xs:element name="vAliqProd" type="TDec_1104">
																				<xs:annotation>
																					<xs:documentation>Alíquota do CIDE  (em reais)</xs:documentation>
																				</xs:annotation>
																			</xs:element>
																			<xs:element name="vCIDE" type="TDec_1302">
																				<xs:annotation>
																					<xs:documentation>Valor do CIDE</xs:documentation>
																				</xs:annotation>
																			</xs:element>
																		</xs:sequence>
																	</xs:complexType>
																</xs:element>
															</xs:sequence>
														</xs:complexType>
													</xs:element>
												</xs:choice>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
									<xs:element name="imposto">
										<xs:annotation>
											<xs:documentation>Tributos incidentes nos produtos ou serviços da NF-e</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="vTotTrib" type="TDec_1302" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor estimado total de impostos federais, estaduais e municipais</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:choice>
													<xs:sequence>
														<xs:element name="ICMS">
															<xs:annotation>
																<xs:documentation>Dados do ICMS Normal e ST</xs:documentation>
															</xs:annotation>
															<xs:complexType>
																<xs:choice>
																	<xs:element name="ICMS00">
																		<xs:annotation>
																			<xs:documentation>Tributação pelo ICMS
00 - Tributada integralmente</xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0-Nacional 
1-Estrangeira - Importação direta; 2-Estrangeira - Adquirida no mercado interno; 3-Nacional, conteudo superior 40%; 4-Nacional, processos produtivos 
básicos; 5-Nacional, conteudo inferior 40%; 6-Estrangeira - Importação direta, com similar nacional, lista CAMEX; 7-Estrangeira - mercado interno, sem simular,
lista CAMEX. 
</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CST">
																					<xs:annotation>
																						<xs:documentation>Tributção pelo ICMS
00 - Tributada integralmente
</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="00"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="modBC">
																					<xs:annotation>
																						<xs:documentation>Modalidade de determinação da BC do ICMS:
0 - Margem Valor Agregado (%);
1 - Pauta (valor);
2 - Preço Tabelado Máximo (valor);
3 - Valor da Operação.</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="0"/>
																							<xs:enumeration value="1"/>
																							<xs:enumeration value="2"/>
																							<xs:enumeration value="3"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="vBC" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pICMS" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMS" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMS10">
																		<xs:annotation>
																			<xs:documentation>Tributação pelo ICMS
10 - Tributada e com cobrança do ICMS por substituição tributária </xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CST">
																					<xs:annotation>
																						<xs:documentation>10 - Tributada e com cobrança do ICMS por substituição tributária </xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="10"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="modBC">
																					<xs:annotation>
																						<xs:documentation>Modalidade de determinação da BC do ICMS:
0 - Margem Valor Agregado (%);
1 - Pauta (valor);
2 - Preço Tabelado Máximo (valor);
3 - Valor da Operação.</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="0"/>
																							<xs:enumeration value="1"/>
																							<xs:enumeration value="2"/>
																							<xs:enumeration value="3"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="vBC" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pICMS" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMS" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="modBCST">
																					<xs:annotation>
																						<xs:documentation>Modalidade de determinação da BC do ICMS ST:
0 – Preço tabelado ou máximo  sugerido;
1 - Lista Negativa (valor);
2 - Lista Positiva (valor);
3 - Lista Neutra (valor);
4 - Margem Valor Agregado (%);
5 - Pauta (valor);</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="0"/>
																							<xs:enumeration value="1"/>
																							<xs:enumeration value="2"/>
																							<xs:enumeration value="3"/>
																							<xs:enumeration value="4"/>
																							<xs:enumeration value="5"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="pMVAST" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual da Margem de Valor Adicionado ICMS ST</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pRedBCST" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual de redução da BC ICMS ST </xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vBCST" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do ICMS ST</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pICMSST" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do ICMS ST</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMSST" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor do ICMS ST</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMS20">
																		<xs:annotation>
																			<xs:documentation>Tributção pelo ICMS
20 - Com redução de base de cálculo </xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CST">
																					<xs:annotation>
																						<xs:documentation>Tributção pelo ICMS
20 - Com redução de base de cálculo</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="20"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="modBC">
																					<xs:annotation>
																						<xs:documentation>Modalidade de determinação da BC do ICMS:
0 - Margem Valor Agregado (%);
1 - Pauta (valor);
2 - Preço Tabelado Máximo (valor);
3 - Valor da Operação.</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="0"/>
																							<xs:enumeration value="1"/>
																							<xs:enumeration value="2"/>
																							<xs:enumeration value="3"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="pRedBC" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Percentual de redução da BC</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vBC" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pICMS" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMS" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMS30">
																		<xs:annotation>
																			<xs:documentation>Tributação pelo ICMS
30 - Isenta ou não tributada e com cobrança do ICMS por substituição tributária</xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CST">
																					<xs:annotation>
																						<xs:documentation>Tributção pelo ICMS
30 - Isenta ou não tributada e com cobrança do ICMS por substituição tributária </xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="30"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="modBCST">
																					<xs:annotation>
																						<xs:documentation>Modalidade de determinação da BC do ICMS ST:
0 – Preço tabelado ou máximo  sugerido;
1 - Lista Negativa (valor);
2 - Lista Positiva (valor);
3 - Lista Neutra (valor);
4 - Margem Valor Agregado (%);
5 - Pauta (valor).</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="0"/>
																							<xs:enumeration value="1"/>
																							<xs:enumeration value="2"/>
																							<xs:enumeration value="3"/>
																							<xs:enumeration value="4"/>
																							<xs:enumeration value="5"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="pMVAST" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual da Margem de Valor Adicionado ICMS ST</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pRedBCST" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual de redução da BC ICMS ST </xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vBCST" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do ICMS ST</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pICMSST" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do ICMS ST</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMSST" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor do ICMS ST</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMS40">
																		<xs:annotation>
																			<xs:documentation>Tributação pelo ICMS
40 - Isenta 
41 - Não tributada 
50 - Suspensão  </xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CST">
																					<xs:annotation>
																						<xs:documentation>Tributação pelo ICMS 
40 - Isenta 
41 - Não tributada 
50 - Suspensão 
51 - Diferimento </xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="40"/>
																							<xs:enumeration value="41"/>
																							<xs:enumeration value="50"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:sequence minOccurs="0">
																					<xs:element name="vICMS" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>O valor do ICMS será informado apenas nas operações com veículos beneficiados com a desoneração condicional do ICMS. (v2.0)</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="motDesICMS">
																						<xs:annotation>
																							<xs:documentation>Este campo será preenchido quando o campo anterior estiver preenchido.
Informar o motivo da desoneração:
1 – Táxi;
2 – Deficiente Físico;
3 – Produtor Agropecuário;
4 – Frotista/Locadora;
5 – Diplomático/Consular;
6 – Utilitários e Motocicletas da Amazônia Ocidental e Áreas de Livre Comércio (Resolução 714/88 e 790/94 – CONTRAN e suas alterações);
7 – SUFRAMA;
8 - Venda a órgão Público;
9 – outros. (v2.0)</xs:documentation>
																						</xs:annotation>
																						<xs:simpleType>
																							<xs:restriction base="xs:string">
																								<xs:whiteSpace value="preserve"/>
																								<xs:enumeration value="1"/>
																								<xs:enumeration value="2"/>
																								<xs:enumeration value="3"/>
																								<xs:enumeration value="4"/>
																								<xs:enumeration value="5"/>
																								<xs:enumeration value="6"/>
																								<xs:enumeration value="7"/>
																								<xs:enumeration value="8"/>
																								<xs:enumeration value="9"/>
																							</xs:restriction>
																						</xs:simpleType>
																					</xs:element>
																				</xs:sequence>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMS51">
																		<xs:annotation>
																			<xs:documentation>Tributção pelo ICMS
51 - Diferimento
A exigência do preenchimento das informações do ICMS diferido fica à critério de cada UF.</xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CST">
																					<xs:annotation>
																						<xs:documentation>Tributção pelo ICMS
20 - Com redução de base de cálculo</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="51"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="modBC" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Modalidade de determinação da BC do ICMS:
0 - Margem Valor Agregado (%);
1 - Pauta (valor);
2 - Preço Tabelado Máximo (valor);
3 - Valor da Operação.</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="0"/>
																							<xs:enumeration value="1"/>
																							<xs:enumeration value="2"/>
																							<xs:enumeration value="3"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="pRedBC" type="TDec_0302" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual de redução da BC</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vBC" type="TDec_1302" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pICMS" type="TDec_0302" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Alíquota do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMS" type="TDec_1302" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Valor do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMS60">
																		<xs:annotation>
																			<xs:documentation>Tributação pelo ICMS
60 - ICMS cobrado anteriormente por substituição tributária </xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CST">
																					<xs:annotation>
																						<xs:documentation>Tributação pelo ICMS 
60 - ICMS cobrado anteriormente por substituição tributária </xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="60"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:sequence minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>NT2010/004</xs:documentation>
																					</xs:annotation>
																					<xs:element name="vBCSTRet" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor da BC do ICMS ST retido anteriormente (v2.0)</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="vICMSSTRet" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor do ICMS ST retido anteriormente  (v2.0)</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																				</xs:sequence>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMS70">
																		<xs:annotation>
																			<xs:documentation>Tributação pelo ICMS 
70 - Com redução de base de cálculo e cobrança do ICMS por substituição tributária </xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CST">
																					<xs:annotation>
																						<xs:documentation>Tributção pelo ICMS
70 - Com redução de base de cálculo e cobrança do ICMS por substituição tributária </xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="70"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="modBC">
																					<xs:annotation>
																						<xs:documentation>Modalidade de determinação da BC do ICMS:
0 - Margem Valor Agregado (%);
1 - Pauta (valor);
2 - Preço Tabelado Máximo (valor);
3 - Valor da Operação.</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="0"/>
																							<xs:enumeration value="1"/>
																							<xs:enumeration value="2"/>
																							<xs:enumeration value="3"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="pRedBC" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Percentual de redução da BC</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vBC" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pICMS" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMS" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor do ICMS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="modBCST">
																					<xs:annotation>
																						<xs:documentation>Modalidade de determinação da BC do ICMS ST:
0 – Preço tabelado ou máximo  sugerido;
1 - Lista Negativa (valor);
2 - Lista Positiva (valor);
3 - Lista Neutra (valor);
4 - Margem Valor Agregado (%);
5 - Pauta (valor).</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="0"/>
																							<xs:enumeration value="1"/>
																							<xs:enumeration value="2"/>
																							<xs:enumeration value="3"/>
																							<xs:enumeration value="4"/>
																							<xs:enumeration value="5"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="pMVAST" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual da Margem de Valor Adicionado ICMS ST</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pRedBCST" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual de redução da BC ICMS ST </xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vBCST" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do ICMS ST</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pICMSST" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do ICMS ST</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMSST" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor do ICMS ST</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMS90">
																		<xs:annotation>
																			<xs:documentation>Tributação pelo ICMS
90 - Outras</xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CST">
																					<xs:annotation>
																						<xs:documentation>Tributção pelo ICMS
90 - Outras</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="90"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:sequence minOccurs="0">
																					<xs:element name="modBC">
																						<xs:annotation>
																							<xs:documentation>Modalidade de determinação da BC do ICMS: 
0 - Margem Valor Agregado (%);
1 - Pauta (valor);
2 - Preço Tabelado Máximo (valor);
3 - Valor da Operação.</xs:documentation>
																						</xs:annotation>
																						<xs:simpleType>
																							<xs:restriction base="xs:string">
																								<xs:whiteSpace value="preserve"/>
																								<xs:enumeration value="0"/>
																								<xs:enumeration value="1"/>
																								<xs:enumeration value="2"/>
																								<xs:enumeration value="3"/>
																							</xs:restriction>
																						</xs:simpleType>
																					</xs:element>
																					<xs:element name="vBC" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor da BC do ICMS</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="pRedBC" type="TDec_0302Opc" minOccurs="0">
																						<xs:annotation>
																							<xs:documentation>Percentual de redução da BC</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="pICMS" type="TDec_0302">
																						<xs:annotation>
																							<xs:documentation>Alíquota do ICMS</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="vICMS" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor do ICMS</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																				</xs:sequence>
																				<xs:sequence minOccurs="0">
																					<xs:element name="modBCST">
																						<xs:annotation>
																							<xs:documentation>Modalidade de determinação da BC do ICMS ST:
0 – Preço tabelado ou máximo  sugerido;
1 - Lista Negativa (valor);
2 - Lista Positiva (valor);
3 - Lista Neutra (valor);
4 - Margem Valor Agregado (%);
5 - Pauta (valor).</xs:documentation>
																						</xs:annotation>
																						<xs:simpleType>
																							<xs:restriction base="xs:string">
																								<xs:whiteSpace value="preserve"/>
																								<xs:enumeration value="0"/>
																								<xs:enumeration value="1"/>
																								<xs:enumeration value="2"/>
																								<xs:enumeration value="3"/>
																								<xs:enumeration value="4"/>
																								<xs:enumeration value="5"/>
																							</xs:restriction>
																						</xs:simpleType>
																					</xs:element>
																					<xs:element name="pMVAST" type="TDec_0302Opc" minOccurs="0">
																						<xs:annotation>
																							<xs:documentation>Percentual da Margem de Valor Adicionado ICMS ST</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="pRedBCST" type="TDec_0302Opc" minOccurs="0">
																						<xs:annotation>
																							<xs:documentation>Percentual de redução da BC ICMS ST </xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="vBCST" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor da BC do ICMS ST</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="pICMSST" type="TDec_0302">
																						<xs:annotation>
																							<xs:documentation>Alíquota do ICMS ST</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="vICMSST" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor do ICMS ST</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																				</xs:sequence>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMSPart">
																		<xs:annotation>
																			<xs:documentation>Partilha do ICMS entre a UF de origem e UF de destino ou a UF definida na legislação
Operação interestadual para consumidor final com partilha do ICMS  devido na operação entre a UF de origem e a UF do destinatário ou ou a UF definida na legislação. (Ex. UF da concessionária de entrega do  veículos) (v2.0)</xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
(v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CST">
																					<xs:annotation>
																						<xs:documentation>Tributação pelo ICMS 
10 - Tributada e com cobrança do ICMS por substituição tributária;
90 – Outros.</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="10"/>
																							<xs:enumeration value="90"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="modBC">
																					<xs:annotation>
																						<xs:documentation>Modalidade de determinação da BC do ICMS: 
0 - Margem Valor Agregado (%);
1 - Pauta (valor);
2 - Preço Tabelado Máximo (valor);
3 - Valor da Operação. (v2.0)</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="0"/>
																							<xs:enumeration value="1"/>
																							<xs:enumeration value="2"/>
																							<xs:enumeration value="3"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="vBC" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do ICMS (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pRedBC" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual de redução da BC (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pICMS" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do ICMS (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMS" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor do ICMS (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="modBCST">
																					<xs:annotation>
																						<xs:documentation>Modalidade de determinação da BC do ICMS ST:
0 – Preço tabelado ou máximo  sugerido;
1 - Lista Negativa (valor);
2 - Lista Positiva (valor);
3 - Lista Neutra (valor);
4 - Margem Valor Agregado (%);
5 - Pauta (valor). (v2.0)</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="0"/>
																							<xs:enumeration value="1"/>
																							<xs:enumeration value="2"/>
																							<xs:enumeration value="3"/>
																							<xs:enumeration value="4"/>
																							<xs:enumeration value="5"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="pMVAST" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual da Margem de Valor Adicionado ICMS ST (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pRedBCST" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual de redução da BC ICMS ST (v2.0) </xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vBCST" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do ICMS ST (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pICMSST" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do ICMS ST (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMSST" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor do ICMS ST (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pBCOp" type="TDec_0302Opc">
																					<xs:annotation>
																						<xs:documentation>Percentual para determinação do valor  da Base de Cálculo da operação própria. (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="UFST" type="TUf">
																					<xs:annotation>
																						<xs:documentation>Sigla da UF para qual é devido o ICMS ST da operação. (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMSST">
																		<xs:annotation>
																			<xs:documentation>Grupo de informação do ICMSST devido para a UF de destino, nas operações interestaduais de produtos que tiveram retenção antecipada de ICMS por ST na UF do remetente. Repasse via Substituto Tributário. (v2.0)</xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
(v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CST">
																					<xs:annotation>
																						<xs:documentation>Tributção pelo ICMS
41-Não Tributado (v2.0)</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="41"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="vBCSTRet" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Informar o valor da BC do ICMS ST retido na UF remetente (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMSSTRet" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation> Informar o valor do ICMS ST retido na UF remetente (iv2.0))</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vBCSTDest" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation> Informar o valor da BC do ICMS ST da UF destino (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMSSTDest" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Informar o valor da BC do ICMS ST da UF destino (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMSSN101">
																		<xs:annotation>
																			<xs:documentation>Tributação do ICMS pelo SIMPLES NACIONAL e CSOSN=101 (v.2.0)</xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
(v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CSOSN">
																					<xs:annotation>
																						<xs:documentation>101- Tributada pelo Simples Nacional com permissão de crédito. (v.2.0)</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="101"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="pCredSN" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota aplicável de cálculo do crédito (Simples Nacional). (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vCredICMSSN" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional) (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMSSN102">
																		<xs:annotation>
																			<xs:documentation>Tributação do ICMS pelo SIMPLES NACIONAL e CSOSN=102, 103, 300 ou 400 (v.2.0))</xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
(v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CSOSN">
																					<xs:annotation>
																						<xs:documentation>102- Tributada pelo Simples Nacional sem permissão de crédito. 
103 – Isenção do ICMS  no Simples Nacional para faixa de receita bruta.
300 – Imune.
400 – Não tributda pelo Simples Nacional (v.2.0) (v.2.0)</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="102"/>
																							<xs:enumeration value="103"/>
																							<xs:enumeration value="300"/>
																							<xs:enumeration value="400"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMSSN201">
																		<xs:annotation>
																			<xs:documentation>Tributação do ICMS pelo SIMPLES NACIONAL e CSOSN=201 (v.2.0)</xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>Origem da mercadoria:
0 – Nacional;
1 – Estrangeira – Importação direta;
2 – Estrangeira – Adquirida no mercado interno. (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CSOSN">
																					<xs:annotation>
																						<xs:documentation>201- Tributada pelo Simples Nacional com permissão de crédito e com cobrança do ICMS por Substituição Tributária (v.2.0)</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="201"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="modBCST">
																					<xs:annotation>
																						<xs:documentation>Modalidade de determinação da BC do ICMS ST:
0 – Preço tabelado ou máximo  sugerido;
1 - Lista Negativa (valor);
2 - Lista Positiva (valor);
3 - Lista Neutra (valor);
4 - Margem Valor Agregado (%);
5 - Pauta (valor). (v2.0)</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="0"/>
																							<xs:enumeration value="1"/>
																							<xs:enumeration value="2"/>
																							<xs:enumeration value="3"/>
																							<xs:enumeration value="4"/>
																							<xs:enumeration value="5"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="pMVAST" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual da Margem de Valor Adicionado ICMS ST (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pRedBCST" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual de redução da BC ICMS ST  (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vBCST" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do ICMS ST (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pICMSST" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do ICMS ST (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMSST" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor do ICMS ST (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pCredSN" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota aplicável de cálculo do crédito (Simples Nacional). (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vCredICMSSN" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional) (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMSSN202">
																		<xs:annotation>
																			<xs:documentation>Tributação do ICMS pelo SIMPLES NACIONAL e CSOSN=202 ou 203 (v.2.0)</xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>Origem da mercadoria:
0 – Nacional;
1 – Estrangeira – Importação direta;
2 – Estrangeira – Adquirida no mercado interno. (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CSOSN">
																					<xs:annotation>
																						<xs:documentation>202- Tributada pelo Simples Nacional sem permissão de crédito e com cobrança do ICMS por Substituição Tributária;
203-  Isenção do ICMS nos Simples Nacional para faixa de receita bruta e com cobrança do ICMS por Substituição Tributária (v.2.0)</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="202"/>
																							<xs:enumeration value="203"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="modBCST">
																					<xs:annotation>
																						<xs:documentation>Modalidade de determinação da BC do ICMS ST:
0 – Preço tabelado ou máximo  sugerido;
1 - Lista Negativa (valor);
2 - Lista Positiva (valor);
3 - Lista Neutra (valor);
4 - Margem Valor Agregado (%);
5 - Pauta (valor). (v2.0)</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="0"/>
																							<xs:enumeration value="1"/>
																							<xs:enumeration value="2"/>
																							<xs:enumeration value="3"/>
																							<xs:enumeration value="4"/>
																							<xs:enumeration value="5"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:element name="pMVAST" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual da Margem de Valor Adicionado ICMS ST (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pRedBCST" type="TDec_0302Opc" minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>Percentual de redução da BC ICMS ST  (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vBCST" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do ICMS ST (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pICMSST" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do ICMS ST (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vICMSST" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor do ICMS ST (v2.0)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMSSN500">
																		<xs:annotation>
																			<xs:documentation>Tributação do ICMS pelo SIMPLES NACIONAL,CRT=1 – Simples Nacional e CSOSN=500 (v.2.0)</xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CSOSN">
																					<xs:annotation>
																						<xs:documentation>500 – ICMS cobrado anterirmente por substituição tributária (substituído) ou por antecipação
(v.2.0)</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="500"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:sequence minOccurs="0">
																					<xs:annotation>
																						<xs:documentation>NT2011/004</xs:documentation>
																					</xs:annotation>
																					<xs:element name="vBCSTRet" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor da BC do ICMS ST retido anteriormente (v2.0) </xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="vICMSSTRet" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor do ICMS ST retido anteriormente  (v2.0)</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																				</xs:sequence>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																	<xs:element name="ICMSSN900">
																		<xs:annotation>
																			<xs:documentation>Tributação do ICMS pelo SIMPLES NACIONAL, CRT=1 – Simples Nacional e CSOSN=900 (v2.0)</xs:documentation>
																		</xs:annotation>
																		<xs:complexType>
																			<xs:sequence>
																				<xs:element name="orig" type="Torig">
																					<xs:annotation>
																						<xs:documentation>origem da mercadoria: 0 - Nacional 
1 - Estrangeira - Importação direta 
2 - Estrangeira - Adquirida no mercado interno 
</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="CSOSN">
																					<xs:annotation>
																						<xs:documentation>Tributação pelo ICMS 900 - Outros(v2.0)</xs:documentation>
																					</xs:annotation>
																					<xs:simpleType>
																						<xs:restriction base="xs:string">
																							<xs:whiteSpace value="preserve"/>
																							<xs:enumeration value="900"/>
																						</xs:restriction>
																					</xs:simpleType>
																				</xs:element>
																				<xs:sequence minOccurs="0">
																					<xs:element name="modBC">
																						<xs:annotation>
																							<xs:documentation>Modalidade de determinação da BC do ICMS: 
0 - Margem Valor Agregado (%);
1 - Pauta (valor);
2 - Preço Tabelado Máximo (valor);
3 - Valor da Operação.</xs:documentation>
																						</xs:annotation>
																						<xs:simpleType>
																							<xs:restriction base="xs:string">
																								<xs:whiteSpace value="preserve"/>
																								<xs:enumeration value="0"/>
																								<xs:enumeration value="1"/>
																								<xs:enumeration value="2"/>
																								<xs:enumeration value="3"/>
																							</xs:restriction>
																						</xs:simpleType>
																					</xs:element>
																					<xs:element name="vBC" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor da BC do ICMS</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="pRedBC" type="TDec_0302Opc" minOccurs="0">
																						<xs:annotation>
																							<xs:documentation>Percentual de redução da BC</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="pICMS" type="TDec_0302">
																						<xs:annotation>
																							<xs:documentation>Alíquota do ICMS</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="vICMS" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor do ICMS</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																				</xs:sequence>
																				<xs:sequence minOccurs="0">
																					<xs:element name="modBCST">
																						<xs:annotation>
																							<xs:documentation>Modalidade de determinação da BC do ICMS ST:
0 – Preço tabelado ou máximo  sugerido;
1 - Lista Negativa (valor);
2 - Lista Positiva (valor);
3 - Lista Neutra (valor);
4 - Margem Valor Agregado (%);
5 - Pauta (valor).</xs:documentation>
																						</xs:annotation>
																						<xs:simpleType>
																							<xs:restriction base="xs:string">
																								<xs:whiteSpace value="preserve"/>
																								<xs:enumeration value="0"/>
																								<xs:enumeration value="1"/>
																								<xs:enumeration value="2"/>
																								<xs:enumeration value="3"/>
																								<xs:enumeration value="4"/>
																								<xs:enumeration value="5"/>
																							</xs:restriction>
																						</xs:simpleType>
																					</xs:element>
																					<xs:element name="pMVAST" type="TDec_0302Opc" minOccurs="0">
																						<xs:annotation>
																							<xs:documentation>Percentual da Margem de Valor Adicionado ICMS ST</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="pRedBCST" type="TDec_0302Opc" minOccurs="0">
																						<xs:annotation>
																							<xs:documentation>Percentual de redução da BC ICMS ST </xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="vBCST" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor da BC do ICMS ST</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="pICMSST" type="TDec_0302">
																						<xs:annotation>
																							<xs:documentation>Alíquota do ICMS ST</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="vICMSST" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor do ICMS ST</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																				</xs:sequence>
																				<xs:sequence minOccurs="0">
																					<xs:element name="pCredSN" type="TDec_0302">
																						<xs:annotation>
																							<xs:documentation>Alíquota aplicável de cálculo do crédito (Simples Nacional). (v2.0)</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																					<xs:element name="vCredICMSSN" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor crédito do ICMS que pode ser aproveitado nos termos do art. 23 da LC 123 (Simples Nacional) (v2.0)</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																				</xs:sequence>
																			</xs:sequence>
																		</xs:complexType>
																	</xs:element>
																</xs:choice>
															</xs:complexType>
														</xs:element>
														<xs:element name="IPI" minOccurs="0">
															<xs:annotation>
																<xs:documentation>Dados do IPI</xs:documentation>
															</xs:annotation>
															<xs:complexType>
																<xs:sequence>
																	<xs:element name="clEnq" minOccurs="0">
																		<xs:annotation>
																			<xs:documentation>Classe de Enquadramento do IPI para Cigarros e Bebidas</xs:documentation>
																		</xs:annotation>
																		<xs:simpleType>
																			<xs:restriction base="TString">
																				<xs:minLength value="1"/>
																				<xs:maxLength value="5"/>
																			</xs:restriction>
																		</xs:simpleType>
																	</xs:element>
																	<xs:element name="CNPJProd" type="TCnpj" minOccurs="0">
																		<xs:annotation>
																			<xs:documentation>CNPJ do produtor da mercadoria, quando diferente do emitente. Somente para os casos de exportação direta ou indireta.</xs:documentation>
																		</xs:annotation>
																	</xs:element>
																	<xs:element name="cSelo" minOccurs="0">
																		<xs:annotation>
																			<xs:documentation>Código do selo de controle do IPI </xs:documentation>
																		</xs:annotation>
																		<xs:simpleType>
																			<xs:restriction base="TString">
																				<xs:minLength value="1"/>
																				<xs:maxLength value="60"/>
																			</xs:restriction>
																		</xs:simpleType>
																	</xs:element>
																	<xs:element name="qSelo" minOccurs="0">
																		<xs:annotation>
																			<xs:documentation>Quantidade de selo de controle do IPI</xs:documentation>
																		</xs:annotation>
																		<xs:simpleType>
																			<xs:restriction base="xs:string">
																				<xs:whiteSpace value="preserve"/>
																				<xs:pattern value="[0-9]{1,12}"/>
																			</xs:restriction>
																		</xs:simpleType>
																	</xs:element>
																	<xs:element name="cEnq">
																		<xs:annotation>
																			<xs:documentation>Código de Enquadramento Legal do IPI (tabela a ser criada pela RFB)</xs:documentation>
																		</xs:annotation>
																		<xs:simpleType>
																			<xs:restriction base="TString">
																				<xs:minLength value="1"/>
																				<xs:maxLength value="3"/>
																			</xs:restriction>
																		</xs:simpleType>
																	</xs:element>
																	<xs:choice>
																		<xs:element name="IPITrib">
																			<xs:complexType>
																				<xs:sequence>
																					<xs:element name="CST">
																						<xs:annotation>
																							<xs:documentation>Código da Situação Tributária do IPI:
00-Entrada com recuperação de crédito
49 - Outras entradas
50-Saída tributada
99-Outras saídas</xs:documentation>
																						</xs:annotation>
																						<xs:simpleType>
																							<xs:restriction base="xs:string">
																								<xs:whiteSpace value="preserve"/>
																								<xs:enumeration value="00"/>
																								<xs:enumeration value="49"/>
																								<xs:enumeration value="50"/>
																								<xs:enumeration value="99"/>
																							</xs:restriction>
																						</xs:simpleType>
																					</xs:element>
																					<xs:choice>
																						<xs:sequence>
																							<xs:element name="vBC" type="TDec_1302">
																								<xs:annotation>
																									<xs:documentation>Valor da BC do IPI</xs:documentation>
																								</xs:annotation>
																							</xs:element>
																							<xs:element name="pIPI" type="TDec_0302">
																								<xs:annotation>
																									<xs:documentation>Alíquota do IPI</xs:documentation>
																								</xs:annotation>
																							</xs:element>
																						</xs:sequence>
																						<xs:sequence>
																							<xs:element name="qUnid" type="TDec_1204">
																								<xs:annotation>
																									<xs:documentation>Quantidade total na unidade padrão para tributação </xs:documentation>
																								</xs:annotation>
																							</xs:element>
																							<xs:element name="vUnid" type="TDec_1104">
																								<xs:annotation>
																									<xs:documentation>Valor por Unidade Tributável. Informar o valor do imposto Pauta por unidade de medida.</xs:documentation>
																								</xs:annotation>
																							</xs:element>
																						</xs:sequence>
																					</xs:choice>
																					<xs:element name="vIPI" type="TDec_1302">
																						<xs:annotation>
																							<xs:documentation>Valor do IPI</xs:documentation>
																						</xs:annotation>
																					</xs:element>
																				</xs:sequence>
																			</xs:complexType>
																		</xs:element>
																		<xs:element name="IPINT">
																			<xs:complexType>
																				<xs:sequence>
																					<xs:element name="CST">
																						<xs:annotation>
																							<xs:documentation>Código da Situação Tributária do IPI:
01-Entrada tributada com alíquota zero
02-Entrada isenta
03-Entrada não-tributada
04-Entrada imune
05-Entrada com suspensão
51-Saída tributada com alíquota zero
52-Saída isenta
53-Saída não-tributada
54-Saída imune
55-Saída com suspensão</xs:documentation>
																						</xs:annotation>
																						<xs:simpleType>
																							<xs:restriction base="xs:string">
																								<xs:whiteSpace value="preserve"/>
																								<xs:enumeration value="01"/>
																								<xs:enumeration value="02"/>
																								<xs:enumeration value="03"/>
																								<xs:enumeration value="04"/>
																								<xs:enumeration value="05"/>
																								<xs:enumeration value="51"/>
																								<xs:enumeration value="52"/>
																								<xs:enumeration value="53"/>
																								<xs:enumeration value="54"/>
																								<xs:enumeration value="55"/>
																							</xs:restriction>
																						</xs:simpleType>
																					</xs:element>
																				</xs:sequence>
																			</xs:complexType>
																		</xs:element>
																	</xs:choice>
																</xs:sequence>
															</xs:complexType>
														</xs:element>
														<xs:element name="II" minOccurs="0">
															<xs:annotation>
																<xs:documentation>Dados do Imposto de Importação</xs:documentation>
															</xs:annotation>
															<xs:complexType>
																<xs:sequence>
																	<xs:element name="vBC" type="TDec_1302">
																		<xs:annotation>
																			<xs:documentation>Base da BC do Imposto de Importação</xs:documentation>
																		</xs:annotation>
																	</xs:element>
																	<xs:element name="vDespAdu" type="TDec_1302">
																		<xs:annotation>
																			<xs:documentation>Valor das despesas aduaneiras</xs:documentation>
																		</xs:annotation>
																	</xs:element>
																	<xs:element name="vII" type="TDec_1302">
																		<xs:annotation>
																			<xs:documentation>Valor do Imposto de Importação</xs:documentation>
																		</xs:annotation>
																	</xs:element>
																	<xs:element name="vIOF" type="TDec_1302">
																		<xs:annotation>
																			<xs:documentation>Valor do Imposto sobre Operações Financeiras</xs:documentation>
																		</xs:annotation>
																	</xs:element>
																</xs:sequence>
															</xs:complexType>
														</xs:element>
													</xs:sequence>
													<xs:element name="ISSQN">
														<xs:annotation>
															<xs:documentation>ISSQN</xs:documentation>
														</xs:annotation>
														<xs:complexType>
															<xs:sequence>
																<xs:element name="vBC" type="TDec_1302">
																	<xs:annotation>
																		<xs:documentation>Valor da BC do ISSQN</xs:documentation>
																	</xs:annotation>
																</xs:element>
																<xs:element name="vAliq" type="TDec_0302">
																	<xs:annotation>
																		<xs:documentation>Alíquota do ISSQN</xs:documentation>
																	</xs:annotation>
																</xs:element>
																<xs:element name="vISSQN" type="TDec_1302">
																	<xs:annotation>
																		<xs:documentation>Valor da do ISSQN</xs:documentation>
																	</xs:annotation>
																</xs:element>
																<xs:element name="cMunFG" type="TCodMunIBGE">
																	<xs:annotation>
																		<xs:documentation>Informar o município de ocorrência do fato gerador do ISSQN. Utilizar a Tabela do IBGE (Anexo VII - Tabela de UF, Município e País). “Atenção, não vincular com os campos B12, C10 ou E10” v2.0</xs:documentation>
																	</xs:annotation>
																</xs:element>
																<xs:element name="cListServ" type="TCListServ">
																	<xs:annotation>
																		<xs:documentation>Informar o Item da lista de serviços da LC 116/03 em que se classifica o serviço.</xs:documentation>
																	</xs:annotation>
																</xs:element>
																<xs:element name="cSitTrib">
																	<xs:annotation>
																		<xs:documentation>Informar o código da tributação do ISSQN:
N – NORMAL;
R – RETIDA;
S –SUBSTITUTA;
I – ISENTA. (v.2.0)
</xs:documentation>
																	</xs:annotation>
																	<xs:simpleType>
																		<xs:restriction base="xs:string">
																			<xs:whiteSpace value="preserve"/>
																			<xs:enumeration value="N"/>
																			<xs:enumeration value="R"/>
																			<xs:enumeration value="S"/>
																			<xs:enumeration value="I"/>
																		</xs:restriction>
																	</xs:simpleType>
																</xs:element>
															</xs:sequence>
														</xs:complexType>
													</xs:element>
												</xs:choice>
												<xs:element name="PIS">
													<xs:annotation>
														<xs:documentation>Dados do PIS</xs:documentation>
													</xs:annotation>
													<xs:complexType>
														<xs:choice>
															<xs:element name="PISAliq">
																<xs:annotation>
																	<xs:documentation>Código de Situação Tributária do PIS.
 01 – Operação Tributável - Base de Cálculo = Valor da Operação Alíquota Normal (Cumulativo/Não Cumulativo);
02 - Operação Tributável - Base de Calculo = Valor da Operação (Alíquota Diferenciada);</xs:documentation>
																</xs:annotation>
																<xs:complexType>
																	<xs:sequence>
																		<xs:element name="CST">
																			<xs:annotation>
																				<xs:documentation>Código de Situação Tributária do PIS.
 01 – Operação Tributável - Base de Cálculo = Valor da Operação Alíquota Normal (Cumulativo/Não Cumulativo);
02 - Operação Tributável - Base de Calculo = Valor da Operação (Alíquota Diferenciada);</xs:documentation>
																			</xs:annotation>
																			<xs:simpleType>
																				<xs:restriction base="xs:string">
																					<xs:whiteSpace value="preserve"/>
																					<xs:enumeration value="01"/>
																					<xs:enumeration value="02"/>
																				</xs:restriction>
																			</xs:simpleType>
																		</xs:element>
																		<xs:element name="vBC" type="TDec_1302">
																			<xs:annotation>
																				<xs:documentation>Valor da BC do PIS</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																		<xs:element name="pPIS" type="TDec_0302">
																			<xs:annotation>
																				<xs:documentation>Alíquota do PIS (em percentual)</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																		<xs:element name="vPIS" type="TDec_1302">
																			<xs:annotation>
																				<xs:documentation>Valor do PIS</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																	</xs:sequence>
																</xs:complexType>
															</xs:element>
															<xs:element name="PISQtde">
																<xs:annotation>
																	<xs:documentation>Código de Situação Tributária do PIS.
03 - Operação Tributável - Base de Calculo = Quantidade Vendida x Alíquota por Unidade de Produto;</xs:documentation>
																</xs:annotation>
																<xs:complexType>
																	<xs:sequence>
																		<xs:element name="CST">
																			<xs:annotation>
																				<xs:documentation>Código de Situação Tributária do PIS.
03 - Operação Tributável - Base de Calculo = Quantidade Vendida x Alíquota por Unidade de Produto;</xs:documentation>
																			</xs:annotation>
																			<xs:simpleType>
																				<xs:restriction base="xs:string">
																					<xs:whiteSpace value="preserve"/>
																					<xs:enumeration value="03"/>
																				</xs:restriction>
																			</xs:simpleType>
																		</xs:element>
																		<xs:element name="qBCProd" type="TDec_1204">
																			<xs:annotation>
																				<xs:documentation>Quantidade Vendida  (NT2011/004)</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																		<xs:element name="vAliqProd" type="TDec_1104v">
																			<xs:annotation>
																				<xs:documentation>Alíquota do PIS (em reais) (NT2011/004)</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																		<xs:element name="vPIS" type="TDec_1302">
																			<xs:annotation>
																				<xs:documentation>Valor do PIS</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																	</xs:sequence>
																</xs:complexType>
															</xs:element>
															<xs:element name="PISNT">
																<xs:annotation>
																	<xs:documentation>Código de Situação Tributária do PIS.
04 - Operação Tributável - Tributação Monofásica - (Alíquota Zero);
06 - Operação Tributável - Alíquota Zero;
07 - Operação Isenta da contribuição;
08 - Operação Sem Incidência da contribuição;
09 - Operação com suspensão da contribuição;</xs:documentation>
																</xs:annotation>
																<xs:complexType>
																	<xs:sequence>
																		<xs:element name="CST">
																			<xs:annotation>
																				<xs:documentation>Código de Situação Tributária do PIS.
04 - Operação Tributável - Tributação Monofásica - (Alíquota Zero);
06 - Operação Tributável - Alíquota Zero;
07 - Operação Isenta da contribuição;
08 - Operação Sem Incidência da contribuição;
09 - Operação com suspensão da contribuição;</xs:documentation>
																			</xs:annotation>
																			<xs:simpleType>
																				<xs:restriction base="xs:string">
																					<xs:whiteSpace value="preserve"/>
																					<xs:enumeration value="04"/>
																					<xs:enumeration value="06"/>
																					<xs:enumeration value="07"/>
																					<xs:enumeration value="08"/>
																					<xs:enumeration value="09"/>
																				</xs:restriction>
																			</xs:simpleType>
																		</xs:element>
																	</xs:sequence>
																</xs:complexType>
															</xs:element>
															<xs:element name="PISOutr">
																<xs:annotation>
																	<xs:documentation>Código de Situação Tributária do PIS.
99 - Outras Operações.</xs:documentation>
																</xs:annotation>
																<xs:complexType>
																	<xs:sequence>
																		<xs:element name="CST">
																			<xs:annotation>
																				<xs:documentation>Código de Situação Tributária do PIS.
99 - Outras Operações.</xs:documentation>
																			</xs:annotation>
																			<xs:simpleType>
																				<xs:restriction base="xs:string">
																					<xs:whiteSpace value="preserve"/>
																					<xs:enumeration value="49"/>
																					<xs:enumeration value="50"/>
																					<xs:enumeration value="51"/>
																					<xs:enumeration value="52"/>
																					<xs:enumeration value="53"/>
																					<xs:enumeration value="54"/>
																					<xs:enumeration value="55"/>
																					<xs:enumeration value="56"/>
																					<xs:enumeration value="60"/>
																					<xs:enumeration value="61"/>
																					<xs:enumeration value="62"/>
																					<xs:enumeration value="63"/>
																					<xs:enumeration value="64"/>
																					<xs:enumeration value="65"/>
																					<xs:enumeration value="66"/>
																					<xs:enumeration value="67"/>
																					<xs:enumeration value="70"/>
																					<xs:enumeration value="71"/>
																					<xs:enumeration value="72"/>
																					<xs:enumeration value="73"/>
																					<xs:enumeration value="74"/>
																					<xs:enumeration value="75"/>
																					<xs:enumeration value="98"/>
																					<xs:enumeration value="99"/>
																				</xs:restriction>
																			</xs:simpleType>
																		</xs:element>
																		<xs:choice>
																			<xs:sequence>
																				<xs:element name="vBC" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do PIS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pPIS" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do PIS (em percentual)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																			<xs:sequence>
																				<xs:element name="qBCProd" type="TDec_1204">
																					<xs:annotation>
																						<xs:documentation>Quantidade Vendida (NT2011/004) </xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vAliqProd" type="TDec_1104v">
																					<xs:annotation>
																						<xs:documentation>Alíquota do PIS (em reais) (NT2011/004)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:choice>
																		<xs:element name="vPIS" type="TDec_1302">
																			<xs:annotation>
																				<xs:documentation>Valor do PIS</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																	</xs:sequence>
																</xs:complexType>
															</xs:element>
														</xs:choice>
													</xs:complexType>
												</xs:element>
												<xs:element name="PISST" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Dados do PIS Substituição Tributária</xs:documentation>
													</xs:annotation>
													<xs:complexType>
														<xs:sequence>
															<xs:choice>
																<xs:sequence>
																	<xs:element name="vBC" type="TDec_1302Opc">
																		<xs:annotation>
																			<xs:documentation>Valor da BC do PIS ST</xs:documentation>
																		</xs:annotation>
																	</xs:element>
																	<xs:element name="pPIS" type="TDec_0302Opc">
																		<xs:annotation>
																			<xs:documentation>Alíquota do PIS ST (em percentual)</xs:documentation>
																		</xs:annotation>
																	</xs:element>
																</xs:sequence>
																<xs:sequence>
																	<xs:element name="qBCProd" type="TDec_1204Opc">
																		<xs:annotation>
																			<xs:documentation>Quantidade Vendida </xs:documentation>
																		</xs:annotation>
																	</xs:element>
																	<xs:element name="vAliqProd" type="TDec_1104Opc">
																		<xs:annotation>
																			<xs:documentation>Alíquota do PIS ST (em reais)</xs:documentation>
																		</xs:annotation>
																	</xs:element>
																</xs:sequence>
															</xs:choice>
															<xs:element name="vPIS" type="TDec_1302Opc">
																<xs:annotation>
																	<xs:documentation>Valor do PIS ST</xs:documentation>
																</xs:annotation>
															</xs:element>
														</xs:sequence>
													</xs:complexType>
												</xs:element>
												<xs:element name="COFINS">
													<xs:annotation>
														<xs:documentation>Dados do COFINS</xs:documentation>
													</xs:annotation>
													<xs:complexType>
														<xs:choice>
															<xs:element name="COFINSAliq">
																<xs:annotation>
																	<xs:documentation>Código de Situação Tributária do COFINS.
 01 – Operação Tributável - Base de Cálculo = Valor da Operação Alíquota Normal (Cumulativo/Não Cumulativo);
02 - Operação Tributável - Base de Calculo = Valor da Operação (Alíquota Diferenciada);</xs:documentation>
																</xs:annotation>
																<xs:complexType>
																	<xs:sequence>
																		<xs:element name="CST">
																			<xs:annotation>
																				<xs:documentation>Código de Situação Tributária do COFINS.
 01 – Operação Tributável - Base de Cálculo = Valor da Operação Alíquota Normal (Cumulativo/Não Cumulativo);
02 - Operação Tributável - Base de Calculo = Valor da Operação (Alíquota Diferenciada);</xs:documentation>
																			</xs:annotation>
																			<xs:simpleType>
																				<xs:restriction base="xs:string">
																					<xs:whiteSpace value="preserve"/>
																					<xs:enumeration value="01"/>
																					<xs:enumeration value="02"/>
																				</xs:restriction>
																			</xs:simpleType>
																		</xs:element>
																		<xs:element name="vBC" type="TDec_1302">
																			<xs:annotation>
																				<xs:documentation>Valor da BC do COFINS</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																		<xs:element name="pCOFINS" type="TDec_0302">
																			<xs:annotation>
																				<xs:documentation>Alíquota do COFINS (em percentual)</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																		<xs:element name="vCOFINS" type="TDec_1302">
																			<xs:annotation>
																				<xs:documentation>Valor do COFINS</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																	</xs:sequence>
																</xs:complexType>
															</xs:element>
															<xs:element name="COFINSQtde">
																<xs:annotation>
																	<xs:documentation>Código de Situação Tributária do COFINS.
03 - Operação Tributável - Base de Calculo = Quantidade Vendida x Alíquota por Unidade de Produto;</xs:documentation>
																</xs:annotation>
																<xs:complexType>
																	<xs:sequence>
																		<xs:element name="CST">
																			<xs:annotation>
																				<xs:documentation>Código de Situação Tributária do COFINS.
03 - Operação Tributável - Base de Calculo = Quantidade Vendida x Alíquota por Unidade de Produto;</xs:documentation>
																			</xs:annotation>
																			<xs:simpleType>
																				<xs:restriction base="xs:string">
																					<xs:enumeration value="03"/>
																				</xs:restriction>
																			</xs:simpleType>
																		</xs:element>
																		<xs:element name="qBCProd" type="TDec_1204">
																			<xs:annotation>
																				<xs:documentation>Quantidade Vendida (NT2011/004)</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																		<xs:element name="vAliqProd" type="TDec_1104v">
																			<xs:annotation>
																				<xs:documentation>Alíquota do COFINS (em reais) (NT2011/004)</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																		<xs:element name="vCOFINS" type="TDec_1302">
																			<xs:annotation>
																				<xs:documentation>Valor do COFINS</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																	</xs:sequence>
																</xs:complexType>
															</xs:element>
															<xs:element name="COFINSNT">
																<xs:annotation>
																	<xs:documentation>Código de Situação Tributária do COFINS:
04 - Operação Tributável - Tributação Monofásica - (Alíquota Zero);
06 - Operação Tributável - Alíquota Zero;
07 - Operação Isenta da contribuição;
08 - Operação Sem Incidência da contribuição;
09 - Operação com suspensão da contribuição;</xs:documentation>
																</xs:annotation>
																<xs:complexType>
																	<xs:sequence>
																		<xs:element name="CST">
																			<xs:annotation>
																				<xs:documentation>Código de Situação Tributária do COFINS:
04 - Operação Tributável - Tributação Monofásica - (Alíquota Zero);
06 - Operação Tributável - Alíquota Zero;
07 - Operação Isenta da contribuição;
08 - Operação Sem Incidência da contribuição;
09 - Operação com suspensão da contribuição;</xs:documentation>
																			</xs:annotation>
																			<xs:simpleType>
																				<xs:restriction base="xs:string">
																					<xs:whiteSpace value="preserve"/>
																					<xs:enumeration value="04"/>
																					<xs:enumeration value="06"/>
																					<xs:enumeration value="07"/>
																					<xs:enumeration value="08"/>
																					<xs:enumeration value="09"/>
																				</xs:restriction>
																			</xs:simpleType>
																		</xs:element>
																	</xs:sequence>
																</xs:complexType>
															</xs:element>
															<xs:element name="COFINSOutr">
																<xs:annotation>
																	<xs:documentation>Código de Situação Tributária do COFINS:
49 - Outras Operações de Saída
50 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno
51 - Operação com Direito a Crédito – Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno
52 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação
53 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
54 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
55 - Operação com Direito a Crédito - Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
56 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
60 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno
61 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno
62 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação
63 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
64 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
65 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
66 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
67 - Crédito Presumido - Outras Operações
70 - Operação de Aquisição sem Direito a Crédito
71 - Operação de Aquisição com Isenção
72 - Operação de Aquisição com Suspensão
73 - Operação de Aquisição a Alíquota Zero
74 - Operação de Aquisição sem Incidência da Contribuição
75 - Operação de Aquisição por Substituição Tributária
98 - Outras Operações de Entrada
99 - Outras Operações.</xs:documentation>
																</xs:annotation>
																<xs:complexType>
																	<xs:sequence>
																		<xs:element name="CST">
																			<xs:annotation>
																				<xs:documentation>Código de Situação Tributária do COFINS:
49 - Outras Operações de Saída
50 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita Tributada no Mercado Interno
51 - Operação com Direito a Crédito – Vinculada Exclusivamente a Receita Não Tributada no Mercado Interno
52 - Operação com Direito a Crédito - Vinculada Exclusivamente a Receita de Exportação
53 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
54 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
55 - Operação com Direito a Crédito - Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
56 - Operação com Direito a Crédito - Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
60 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Tributada no Mercado Interno
61 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita Não-Tributada no Mercado Interno
62 - Crédito Presumido - Operação de Aquisição Vinculada Exclusivamente a Receita de Exportação
63 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno
64 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas no Mercado Interno e de Exportação
65 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Não-Tributadas no Mercado Interno e de Exportação
66 - Crédito Presumido - Operação de Aquisição Vinculada a Receitas Tributadas e Não-Tributadas no Mercado Interno, e de Exportação
67 - Crédito Presumido - Outras Operações
70 - Operação de Aquisição sem Direito a Crédito
71 - Operação de Aquisição com Isenção
72 - Operação de Aquisição com Suspensão
73 - Operação de Aquisição a Alíquota Zero
74 - Operação de Aquisição sem Incidência da Contribuição
75 - Operação de Aquisição por Substituição Tributária
98 - Outras Operações de Entrada
99 - Outras Operações.</xs:documentation>
																			</xs:annotation>
																			<xs:simpleType>
																				<xs:restriction base="xs:string">
																					<xs:whiteSpace value="preserve"/>
																					<xs:enumeration value="49"/>
																					<xs:enumeration value="50"/>
																					<xs:enumeration value="51"/>
																					<xs:enumeration value="52"/>
																					<xs:enumeration value="53"/>
																					<xs:enumeration value="54"/>
																					<xs:enumeration value="55"/>
																					<xs:enumeration value="56"/>
																					<xs:enumeration value="60"/>
																					<xs:enumeration value="61"/>
																					<xs:enumeration value="62"/>
																					<xs:enumeration value="63"/>
																					<xs:enumeration value="64"/>
																					<xs:enumeration value="65"/>
																					<xs:enumeration value="66"/>
																					<xs:enumeration value="67"/>
																					<xs:enumeration value="70"/>
																					<xs:enumeration value="71"/>
																					<xs:enumeration value="72"/>
																					<xs:enumeration value="73"/>
																					<xs:enumeration value="74"/>
																					<xs:enumeration value="75"/>
																					<xs:enumeration value="98"/>
																					<xs:enumeration value="99"/>
																				</xs:restriction>
																			</xs:simpleType>
																		</xs:element>
																		<xs:choice>
																			<xs:sequence>
																				<xs:element name="vBC" type="TDec_1302">
																					<xs:annotation>
																						<xs:documentation>Valor da BC do COFINS</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="pCOFINS" type="TDec_0302">
																					<xs:annotation>
																						<xs:documentation>Alíquota do COFINS (em percentual)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																			<xs:sequence>
																				<xs:element name="qBCProd" type="TDec_1204">
																					<xs:annotation>
																						<xs:documentation>Quantidade Vendida (NT2011/004) </xs:documentation>
																					</xs:annotation>
																				</xs:element>
																				<xs:element name="vAliqProd" type="TDec_1104v">
																					<xs:annotation>
																						<xs:documentation>Alíquota do COFINS (em reais) (NT2011/004)</xs:documentation>
																					</xs:annotation>
																				</xs:element>
																			</xs:sequence>
																		</xs:choice>
																		<xs:element name="vCOFINS" type="TDec_1302">
																			<xs:annotation>
																				<xs:documentation>Valor do COFINS</xs:documentation>
																			</xs:annotation>
																		</xs:element>
																	</xs:sequence>
																</xs:complexType>
															</xs:element>
														</xs:choice>
													</xs:complexType>
												</xs:element>
												<xs:element name="COFINSST" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Dados do COFINS da Substituição Tributaria;</xs:documentation>
													</xs:annotation>
													<xs:complexType>
														<xs:sequence>
															<xs:choice>
																<xs:sequence>
																	<xs:element name="vBC" type="TDec_1302Opc">
																		<xs:annotation>
																			<xs:documentation>Valor da BC do COFINS ST</xs:documentation>
																		</xs:annotation>
																	</xs:element>
																	<xs:element name="pCOFINS" type="TDec_0302Opc">
																		<xs:annotation>
																			<xs:documentation>Alíquota do COFINS ST(em percentual)</xs:documentation>
																		</xs:annotation>
																	</xs:element>
																</xs:sequence>
																<xs:sequence>
																	<xs:element name="qBCProd" type="TDec_1204Opc">
																		<xs:annotation>
																			<xs:documentation>Quantidade Vendida </xs:documentation>
																		</xs:annotation>
																	</xs:element>
																	<xs:element name="vAliqProd" type="TDec_1104Opc">
																		<xs:annotation>
																			<xs:documentation>Alíquota do COFINS ST(em reais)</xs:documentation>
																		</xs:annotation>
																	</xs:element>
																</xs:sequence>
															</xs:choice>
															<xs:element name="vCOFINS" type="TDec_1302Opc">
																<xs:annotation>
																	<xs:documentation>Valor do COFINS ST</xs:documentation>
																</xs:annotation>
															</xs:element>
														</xs:sequence>
													</xs:complexType>
												</xs:element>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
									<xs:element name="infAdProd" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Informações adicionais do produto (norma referenciada, informações complementares, etc)</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:minLength value="1"/>
												<xs:maxLength value="500"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
								</xs:sequence>
								<xs:attribute name="nItem" use="required">
									<xs:annotation>
										<xs:documentation>Número do item do NF</xs:documentation>
									</xs:annotation>
									<xs:simpleType>
										<xs:restriction base="xs:string">
											<xs:whiteSpace value="preserve"/>
											<xs:pattern value="[1-9]{1}[0-9]{0,1}|[1-8]{1}[0-9]{2}|[9]{1}[0-8]{1}[0-9]{1}|[9]{1}[9]{1}[0]{1}"/>
										</xs:restriction>
									</xs:simpleType>
								</xs:attribute>
							</xs:complexType>
						</xs:element>
						<xs:element name="total">
							<xs:annotation>
								<xs:documentation>Dados dos totais da NF-e</xs:documentation>
							</xs:annotation>
							<xs:complexType>
								<xs:sequence>
									<xs:element name="ICMSTot">
										<xs:annotation>
											<xs:documentation>Totais referentes ao ICMS</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="vBC" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>BC do ICMS</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vICMS" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor Total do ICMS</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vBCST" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>BC do ICMS ST</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vST" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor Total do ICMS ST</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vProd" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor Total dos produtos e serviços</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vFrete" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor Total do Frete</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vSeg" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor Total do Seguro</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vDesc" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor Total do Desconto</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vII" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor Total do II</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vIPI" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor Total do IPI</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vPIS" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor do PIS</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vCOFINS" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor do COFINS</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vOutro" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Outras Despesas acessórias</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vNF" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor Total da NF-e</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vTotTrib" type="TDec_1302" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor estimado total de impostos federais, estaduais e municipais</xs:documentation>
													</xs:annotation>
												</xs:element>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
									<xs:element name="ISSQNtot" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Totais referentes ao ISSQN</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="vServ" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor Total dos Serviços sob não-incidência ou não tributados pelo ICMS </xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vBC" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Base de Cálculo do ISS</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vISS" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor Total do ISS</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vPIS" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor do PIS sobre serviços</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vCOFINS" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor do COFINS sobre serviços</xs:documentation>
													</xs:annotation>
												</xs:element>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
									<xs:element name="retTrib" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Retenção de Tributos Federais</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="vRetPIS" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor Retido de PIS</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vRetCOFINS" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor Retido de COFINS</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vRetCSLL" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor Retido de CSLL</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vBCIRRF" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Base de Cálculo do IRRF</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vIRRF" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor Retido de IRRF</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vBCRetPrev" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Base de Cálculo da Retenção da Previdêncica Social</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vRetPrev" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor da Retenção da Previdêncica Social</xs:documentation>
													</xs:annotation>
												</xs:element>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
								</xs:sequence>
							</xs:complexType>
						</xs:element>
						<xs:element name="transp">
							<xs:annotation>
								<xs:documentation>Dados dos transportes da NF-e</xs:documentation>
							</xs:annotation>
							<xs:complexType>
								<xs:sequence>
									<xs:element name="modFrete">
										<xs:annotation>
											<xs:documentation>Modalidade do frete
0- Por conta do emitente;
1- Por conta do destinatário/remetente;
2- Por conta de terceiros;
9- Sem frete (v2.0)</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="xs:string">
												<xs:whiteSpace value="preserve"/>
												<xs:enumeration value="0"/>
												<xs:enumeration value="1"/>
												<xs:enumeration value="2"/>
												<xs:enumeration value="9"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="transporta" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Dados do transportador</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:choice minOccurs="0">
													<xs:element name="CNPJ" type="TCnpj">
														<xs:annotation>
															<xs:documentation>CNPJ do transportador</xs:documentation>
														</xs:annotation>
													</xs:element>
													<xs:element name="CPF" type="TCpf">
														<xs:annotation>
															<xs:documentation>CPF do transportador</xs:documentation>
														</xs:annotation>
													</xs:element>
												</xs:choice>
												<xs:element name="xNome" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Razão Social ou nome</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:maxLength value="60"/>
															<xs:minLength value="1"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="IE" type="TIeDest" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Inscrição Estadual (v2.0)</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="xEnder" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Endereço completo</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:minLength value="1"/>
															<xs:maxLength value="60"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="xMun" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Nome do munícipio</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:maxLength value="60"/>
															<xs:minLength value="1"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="UF" type="TUf" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Sigla da UF</xs:documentation>
													</xs:annotation>
												</xs:element>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
									<xs:element name="retTransp" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Dados da retenção  ICMS do Transporte</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="vServ" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor do Serviço</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vBCRet" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>BC da Retenção do ICMS</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="pICMSRet" type="TDec_0302">
													<xs:annotation>
														<xs:documentation>Alíquota da Retenção</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vICMSRet" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>Valor do ICMS Retido</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="CFOP" type="TCfopTransp">
													<xs:annotation>
														<xs:documentation>Código Fiscal de Operações e Prestações // PL_006f - alterado para permitir somente CFOP de transportes </xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="cMunFG" type="TCodMunIBGE">
													<xs:annotation>
														<xs:documentation>Código do Município de Ocorrência do Fato Gerador (utilizar a tabela do IBGE)</xs:documentation>
													</xs:annotation>
												</xs:element>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
									<xs:choice>
										<xs:sequence minOccurs="0">
											<xs:element name="veicTransp" type="TVeiculo" minOccurs="0">
												<xs:annotation>
													<xs:documentation>Dados do veículo</xs:documentation>
												</xs:annotation>
											</xs:element>
											<xs:element name="reboque" type="TVeiculo" minOccurs="0" maxOccurs="5">
												<xs:annotation>
													<xs:documentation>Dados do reboque/Dolly (v2.0)</xs:documentation>
												</xs:annotation>
											</xs:element>
										</xs:sequence>
										<xs:element name="vagao" minOccurs="0">
											<xs:annotation>
												<xs:documentation>Identificação do vagão (v2.0)</xs:documentation>
											</xs:annotation>
											<xs:simpleType>
												<xs:restriction base="TString">
													<xs:minLength value="1"/>
													<xs:maxLength value="20"/>
												</xs:restriction>
											</xs:simpleType>
										</xs:element>
										<xs:element name="balsa" minOccurs="0">
											<xs:annotation>
												<xs:documentation>Identificação da balsa (v2.0)</xs:documentation>
											</xs:annotation>
											<xs:simpleType>
												<xs:restriction base="TString">
													<xs:minLength value="1"/>
													<xs:maxLength value="20"/>
												</xs:restriction>
											</xs:simpleType>
										</xs:element>
									</xs:choice>
									<xs:element name="vol" minOccurs="0" maxOccurs="5000">
										<xs:annotation>
											<xs:documentation>Dados dos volumes</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="qVol" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Quantidade de volumes transportados</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="xs:string">
															<xs:whiteSpace value="preserve"/>
															<xs:pattern value="[0-9]{1,15}"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="esp" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Espécie dos volumes transportados</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:minLength value="1"/>
															<xs:maxLength value="60"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="marca" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Marca dos volumes transportados</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:minLength value="1"/>
															<xs:maxLength value="60"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="nVol" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Numeração dos volumes transportados</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:minLength value="1"/>
															<xs:maxLength value="60"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="pesoL" type="TDec_1203" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Peso líquido (em kg)</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="pesoB" type="TDec_1203" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Peso bruto (em kg)</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="lacres" minOccurs="0" maxOccurs="5000">
													<xs:complexType>
														<xs:sequence>
															<xs:element name="nLacre">
																<xs:annotation>
																	<xs:documentation>Número dos Lacres</xs:documentation>
																</xs:annotation>
																<xs:simpleType>
																	<xs:restriction base="TString">
																		<xs:minLength value="1"/>
																		<xs:maxLength value="60"/>
																	</xs:restriction>
																</xs:simpleType>
															</xs:element>
														</xs:sequence>
													</xs:complexType>
												</xs:element>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
								</xs:sequence>
							</xs:complexType>
						</xs:element>
						<xs:element name="cobr" minOccurs="0">
							<xs:annotation>
								<xs:documentation>Dados da cobrança da NF-e</xs:documentation>
							</xs:annotation>
							<xs:complexType>
								<xs:sequence>
									<xs:element name="fat" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Dados da fatura</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="nFat" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Número da fatura</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:minLength value="1"/>
															<xs:maxLength value="60"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="vOrig" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor original da fatura</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vDesc" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor do desconto da fatura</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vLiq" type="TDec_1302Opc" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Valor líquido da fatura</xs:documentation>
													</xs:annotation>
												</xs:element>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
									<xs:element name="dup" minOccurs="0" maxOccurs="120">
										<xs:annotation>
											<xs:documentation>Dados das duplicatas NT 2011/004</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="nDup" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Número da duplicata</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:maxLength value="60"/>
															<xs:minLength value="1"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="dVenc" type="TData" minOccurs="0">
													<xs:annotation>
														<xs:documentation>Data de vencimento da duplicata (AAAA-MM-DD)</xs:documentation>
													</xs:annotation>
												</xs:element>
												<xs:element name="vDup" type="TDec_1302Opc">
													<xs:annotation>
														<xs:documentation>Valor da duplicata</xs:documentation>
													</xs:annotation>
												</xs:element>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
								</xs:sequence>
							</xs:complexType>
						</xs:element>
						<xs:element name="infAdic" minOccurs="0">
							<xs:annotation>
								<xs:documentation>Informações adicionais da NF-e</xs:documentation>
							</xs:annotation>
							<xs:complexType>
								<xs:sequence>
									<xs:element name="infAdFisco" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Informações adicionais de interesse do Fisco (v2.0)</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:maxLength value="2000"/>
												<xs:minLength value="1"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="infCpl" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Informações complementares de interesse do Contribuinte</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:maxLength value="5000"/>
												<xs:minLength value="1"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="obsCont" minOccurs="0" maxOccurs="10">
										<xs:annotation>
											<xs:documentation>Campo de uso livre do contribuinte informar o nome do campo no atributo xCampo e o conteúdo do campo no xTexto</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="xTexto">
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:minLength value="1"/>
															<xs:maxLength value="60"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
											</xs:sequence>
											<xs:attribute name="xCampo" use="required">
												<xs:simpleType>
													<xs:restriction base="TString">
														<xs:minLength value="1"/>
														<xs:maxLength value="20"/>
													</xs:restriction>
												</xs:simpleType>
											</xs:attribute>
										</xs:complexType>
									</xs:element>
									<xs:element name="obsFisco" minOccurs="0" maxOccurs="10">
										<xs:annotation>
											<xs:documentation>Campo de uso exclusivo do Fisco informar o nome do campo no atributo xCampo e o conteúdo do campo no xTexto</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="xTexto">
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:minLength value="1"/>
															<xs:maxLength value="60"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
											</xs:sequence>
											<xs:attribute name="xCampo" use="required">
												<xs:simpleType>
													<xs:restriction base="TString">
														<xs:minLength value="1"/>
														<xs:maxLength value="20"/>
													</xs:restriction>
												</xs:simpleType>
											</xs:attribute>
										</xs:complexType>
									</xs:element>
									<xs:element name="procRef" minOccurs="0" maxOccurs="100">
										<xs:annotation>
											<xs:documentation>Grupo de informações do  processo referenciado</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="nProc">
													<xs:annotation>
														<xs:documentation>Indentificador do processo ou ato concessório</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:minLength value="1"/>
															<xs:maxLength value="60"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="indProc">
													<xs:annotation>
														<xs:documentation>Origem do processo, informar com:
0 - SEFAZ;
1 - Justiça Federal;
2 - Justiça Estadual;
3 - Secex/RFB;
9 - Outros</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="xs:string">
															<xs:whiteSpace value="preserve"/>
															<xs:enumeration value="0"/>
															<xs:enumeration value="1"/>
															<xs:enumeration value="2"/>
															<xs:enumeration value="3"/>
															<xs:enumeration value="9"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
								</xs:sequence>
							</xs:complexType>
						</xs:element>
						<xs:element name="exporta" minOccurs="0">
							<xs:annotation>
								<xs:documentation>Informações de exportação</xs:documentation>
							</xs:annotation>
							<xs:complexType>
								<xs:sequence>
									<xs:element name="UFEmbarq" type="TUf">
										<xs:annotation>
											<xs:documentation>Sigla da UF onde ocorrerá o embarque dos produtos</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="xLocEmbarq">
										<xs:annotation>
											<xs:documentation>Local onde ocorrerá o embarque dos produtos</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:minLength value="1"/>
												<xs:maxLength value="60"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
								</xs:sequence>
							</xs:complexType>
						</xs:element>
						<xs:element name="compra" minOccurs="0">
							<xs:annotation>
								<xs:documentation>Informações de compras  (Nota de Empenho, Pedido e Contrato)</xs:documentation>
							</xs:annotation>
							<xs:complexType>
								<xs:sequence>
									<xs:element name="xNEmp" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Informação da Nota de Empenho de compras públicas (NT2011/004)</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:minLength value="1"/>
												<xs:maxLength value="22"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="xPed" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Informação do pedido</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:minLength value="1"/>
												<xs:maxLength value="60"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="xCont" minOccurs="0">
										<xs:annotation>
											<xs:documentation>Informação do contrato</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:minLength value="1"/>
												<xs:maxLength value="60"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
								</xs:sequence>
							</xs:complexType>
						</xs:element>
						<xs:element name="cana" minOccurs="0">
							<xs:annotation>
								<xs:documentation>Informações de registro aquisições de cana // v2.0</xs:documentation>
							</xs:annotation>
							<xs:complexType>
								<xs:sequence>
									<xs:element name="safra">
										<xs:annotation>
											<xs:documentation>Identificação da safra // v2.0</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="TString">
												<xs:minLength value="4"/>
												<xs:maxLength value="9"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="ref">
										<xs:annotation>
											<xs:documentation>Mês e Ano de Referência, formato: MM/AAAA // 2.0</xs:documentation>
										</xs:annotation>
										<xs:simpleType>
											<xs:restriction base="xs:string">
												<xs:whiteSpace value="preserve"/>
												<xs:pattern value="(0[1-9]|1[0-2])([/][2][0-9][0-9][0-9])"/>
											</xs:restriction>
										</xs:simpleType>
									</xs:element>
									<xs:element name="forDia" maxOccurs="31">
										<xs:annotation>
											<xs:documentation>Fornecimentos diários // v2.0</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="qtde" type="TDec_1110">
													<xs:annotation>
														<xs:documentation>Quantidade em quilogramas - peso líquido // v2.0</xs:documentation>
													</xs:annotation>
												</xs:element>
											</xs:sequence>
											<xs:attribute name="dia" use="required">
												<xs:annotation>
													<xs:documentation>Número do dia // v2.0</xs:documentation>
												</xs:annotation>
												<xs:simpleType>
													<xs:restriction base="xs:string">
														<xs:whiteSpace value="preserve"/>
														<xs:pattern value="[1-9]|[1][0-9]|[2][0-9]|[3][0-1]?"/>
													</xs:restriction>
												</xs:simpleType>
											</xs:attribute>
										</xs:complexType>
										<!--<xs:unique name="pk_Dia">
											<xs:selector xpath="./*"/>
											<xs:field xpath="@dia"/>
										</xs:unique>-->
									</xs:element>
									<xs:element name="qTotMes" type="TDec_1110">
										<xs:annotation>
											<xs:documentation>Total do mês // v2.0</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="qTotAnt" type="TDec_1110">
										<xs:annotation>
											<xs:documentation>Total Anterior // v2.0</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="qTotGer" type="TDec_1110">
										<xs:annotation>
											<xs:documentation>Total Geral // v2.0</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="deduc" minOccurs="0" maxOccurs="10">
										<xs:annotation>
											<xs:documentation>Deduções - Taxas e Contribuições // v2.0</xs:documentation>
										</xs:annotation>
										<xs:complexType>
											<xs:sequence>
												<xs:element name="xDed">
													<xs:annotation>
														<xs:documentation>Descrição da Dedução // v2.0</xs:documentation>
													</xs:annotation>
													<xs:simpleType>
														<xs:restriction base="TString">
															<xs:minLength value="1"/>
															<xs:maxLength value="60"/>
														</xs:restriction>
													</xs:simpleType>
												</xs:element>
												<xs:element name="vDed" type="TDec_1302">
													<xs:annotation>
														<xs:documentation>valor da dedução // v2.0</xs:documentation>
													</xs:annotation>
												</xs:element>
											</xs:sequence>
										</xs:complexType>
									</xs:element>
									<xs:element name="vFor" type="TDec_1302">
										<xs:annotation>
											<xs:documentation>Valor  dos fornecimentos // v2.0</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="vTotDed" type="TDec_1302">
										<xs:annotation>
											<xs:documentation>Valor Total das Deduções // v2.0</xs:documentation>
										</xs:annotation>
									</xs:element>
									<xs:element name="vLiqFor" type="TDec_1302">
										<xs:annotation>
											<xs:documentation>Valor Líquido dos fornecimentos // v2.0</xs:documentation>
										</xs:annotation>
									</xs:element>
								</xs:sequence>
							</xs:complexType>
						</xs:element>
					</xs:sequence>
					<xs:attribute name="versao" type="TVerNFe" use="required">
						<xs:annotation>
							<xs:documentation>Versão do leiaute (v2.0)</xs:documentation>
						</xs:annotation>
					</xs:attribute>
					<xs:attribute name="Id" use="required">
						<xs:annotation>
							<xs:documentation>PL_005d - 11/08/09 - validação do Id</xs:documentation>
						</xs:annotation>
						<xs:simpleType>
							<xs:restriction base="xs:ID">
								<xs:pattern value="NFe[0-9]{44}"/>
							</xs:restriction>
						</xs:simpleType>
					</xs:attribute>
				</xs:complexType>
				<!--<xs:unique name="pk_nItem">
					<xs:selector xpath="./*"/>
					<xs:field xpath="@nItem"/>
				</xs:unique>-->
			</xs:element>
			<xs:element ref="Signature"/>
		</xs:sequence>
	</xs:complexType>
	<xs:complexType name="TProtNFe">
		<xs:annotation>
			<xs:documentation>Tipo Protocolo de status resultado do processamento da NF-e</xs:documentation>
		</xs:annotation>
		<xs:sequence>
			<xs:element name="infProt">
				<xs:annotation>
					<xs:documentation>Dados do protocolo de status</xs:documentation>
				</xs:annotation>
				<xs:complexType>
					<xs:sequence>
						<xs:element name="tpAmb" type="TAmb">
							<xs:annotation>
								<xs:documentation>Identificação do Ambiente:
1 - Produção
2 - Homologação</xs:documentation>
							</xs:annotation>
						</xs:element>
						<xs:element name="verAplic" type="TVerAplic">
							<xs:annotation>
								<xs:documentation>Versão do Aplicativo que processou a NF-e</xs:documentation>
							</xs:annotation>
						</xs:element>
						<xs:element name="chNFe" type="TChNFe">
							<xs:annotation>
								<xs:documentation>Chaves de acesso da NF-e, compostas por: UF do emitente, AAMM da emissão da NFe, CNPJ do emitente, modelo, série e número da NF-e e código numérico+DV.</xs:documentation>
							</xs:annotation>
						</xs:element>
						<xs:element name="dhRecbto" type="xs:dateTime">
							<xs:annotation>
								<xs:documentation>Data e hora de processamento, no formato AAAA-MM-DDTHH:MM:SS. Deve ser preenchida com data e hora da gravação no Banco em caso de Confirmação. Em caso de Rejeição, com data e hora do recebimento do Lote de NF-e enviado.</xs:documentation>
							</xs:annotation>
						</xs:element>
						<xs:element name="nProt" type="TProt" minOccurs="0">
							<xs:annotation>
								<xs:documentation>Número do Protocolo de Status da NF-e. 1 posição (1 – Secretaria de Fazenda Estadual 2 – Receita Federal); 2 - códiga da UF - 2 posições ano; 10 seqüencial no ano.</xs:documentation>
							</xs:annotation>
						</xs:element>
						<xs:element name="digVal" type="DigestValueType" minOccurs="0">
							<xs:annotation>
								<xs:documentation>Digest Value da NF-e processada. Utilizado para conferir a integridade da NF-e original.</xs:documentation>
							</xs:annotation>
						</xs:element>
						<xs:element name="cStat" type="TStat">
							<xs:annotation>
								<xs:documentation>Código do status da mensagem enviada.</xs:documentation>
							</xs:annotation>
						</xs:element>
						<xs:element name="xMotivo" type="TMotivo">
							<xs:annotation>
								<xs:documentation>Descrição literal do status do serviço solicitado.</xs:documentation>
							</xs:annotation>
						</xs:element>
					</xs:sequence>
					<xs:attribute name="Id" type="xs:ID" use="optional"/>
				</xs:complexType>
			</xs:element>
			<xs:element ref="Signature" minOccurs="0"/>
		</xs:sequence>
		<xs:attribute name="versao" type="TVerNFe" use="required"/>
	</xs:complexType>
	<xs:complexType name="TEndereco">
		<xs:annotation>
			<xs:documentation>Tipo Dados do Endereço  // 24/10/08 - tamanho mínimo</xs:documentation>
		</xs:annotation>
		<xs:sequence>
			<xs:element name="xLgr">
				<xs:annotation>
					<xs:documentation>Logradouro</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="2"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="nro">
				<xs:annotation>
					<xs:documentation>Número</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="1"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="xCpl" minOccurs="0">
				<xs:annotation>
					<xs:documentation>Complemento</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="1"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="xBairro">
				<xs:annotation>
					<xs:documentation>Bairro</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="1"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="cMun" type="TCodMunIBGE">
				<xs:annotation>
					<xs:documentation>Código do município (utilizar a tabela do IBGE), informar 9999999 para operações com o exterior.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="xMun">
				<xs:annotation>
					<xs:documentation>Nome do município, informar EXTERIOR para operações com o exterior.</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="2"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="UF" type="TUf">
				<xs:annotation>
					<xs:documentation>Sigla da UF, informar EX para operações com o exterior.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="CEP" minOccurs="0">
				<xs:annotation>
					<xs:documentation>CEP</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xs:whiteSpace value="preserve"/>
						<xs:pattern value="[0-9]{8}"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="cPais" type="Tpais" minOccurs="0">
				<xs:annotation>
					<xs:documentation>Código do país</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="xPais" minOccurs="0">
				<xs:annotation>
					<xs:documentation>Nome do país</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="2"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="fone" minOccurs="0">
				<xs:annotation>
					<xs:documentation>Telefone, preencher com Código DDD + número do telefone , nas operações com exterior é permtido informar o código do país + código da localidade + número do telefone</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xs:whiteSpace value="preserve"/>
						<xs:pattern value="[0-9]{6,14}"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<xs:complexType name="TEnderEmi">
		<xs:annotation>
			<xs:documentation>Tipo Dados do Endereço do Emitente  // 24/10/08 - desmembrado / tamanho mínimo</xs:documentation>
		</xs:annotation>
		<xs:sequence>
			<xs:element name="xLgr">
				<xs:annotation>
					<xs:documentation>Logradouro</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="2"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="nro">
				<xs:annotation>
					<xs:documentation>Número</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="1"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="xCpl" minOccurs="0">
				<xs:annotation>
					<xs:documentation>Complemento</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="1"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="xBairro">
				<xs:annotation>
					<xs:documentation>Bairro</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="2"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="cMun" type="TCodMunIBGE">
				<xs:annotation>
					<xs:documentation>Código do município</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="xMun">
				<xs:annotation>
					<xs:documentation>Nome do município</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="2"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="UF" type="TUfEmi">
				<xs:annotation>
					<xs:documentation>Sigla da UF</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="CEP">
				<xs:annotation>
					<xs:documentation>CEP - NT 2011/004</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xs:whiteSpace value="preserve"/>
						<xs:pattern value="[0-9]{8}"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="cPais" minOccurs="0">
				<xs:annotation>
					<xs:documentation>Código do país</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:enumeration value="1058"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="xPais" minOccurs="0">
				<xs:annotation>
					<xs:documentation>Nome do país</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:enumeration value="Brasil"/>
						<xs:enumeration value="BRASIL"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="fone" minOccurs="0">
				<xs:annotation>
					<xs:documentation>Preencher com Código DDD + número do telefone (v.2.0)</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xs:whiteSpace value="preserve"/>
						<xs:pattern value="[0-9]{6,14}"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<xs:complexType name="TLocal">
		<xs:annotation>
			<xs:documentation>Tipo Dados do Local de Retirada ou Entrega // 24/10/08 - tamanho mínimo // v2.0</xs:documentation>
		</xs:annotation>
		<xs:sequence>
			<xs:choice>
				<xs:element name="CNPJ" type="TCnpjOpc">
					<xs:annotation>
						<xs:documentation>CNPJ</xs:documentation>
					</xs:annotation>
				</xs:element>
				<xs:element name="CPF" type="TCpf">
					<xs:annotation>
						<xs:documentation>CPF (v2.0)</xs:documentation>
					</xs:annotation>
				</xs:element>
			</xs:choice>
			<xs:element name="xLgr">
				<xs:annotation>
					<xs:documentation>Logradouro</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="2"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="nro">
				<xs:annotation>
					<xs:documentation>Número</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="1"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="xCpl" minOccurs="0">
				<xs:annotation>
					<xs:documentation>Complemento</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="1"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="xBairro">
				<xs:annotation>
					<xs:documentation>Bairro</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="1"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="cMun" type="TCodMunIBGE">
				<xs:annotation>
					<xs:documentation>Código do município (utilizar a tabela do IBGE)</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="xMun">
				<xs:annotation>
					<xs:documentation>Nome do município</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:maxLength value="60"/>
						<xs:minLength value="2"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="UF" type="TUf">
				<xs:annotation>
					<xs:documentation>Sigla da UF</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<xs:complexType name="TVeiculo">
		<xs:annotation>
			<xs:documentation>Tipo Dados do Veículo</xs:documentation>
		</xs:annotation>
		<xs:sequence>
			<xs:element name="placa">
				<xs:annotation>
					<xs:documentation>Placa do veículo (NT2011/004)</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xs:whiteSpace value="preserve"/>
						<xs:pattern value="[A-Z]{2,3}[0-9]{4}|[A-Z]{3,4}[0-9]{3}"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="UF" type="TUf">
				<xs:annotation>
					<xs:documentation>Sigla da UF</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="RNTC" minOccurs="0">
				<xs:annotation>
					<xs:documentation>Registro Nacional de Transportador de Carga (ANTT)</xs:documentation>
				</xs:annotation>
				<xs:simpleType>
					<xs:restriction base="TString">
						<xs:minLength value="1"/>
						<xs:maxLength value="20"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<xs:simpleType name="TCfop">
		<xs:annotation>
			<xs:documentation>Tipo CFOP // maio/2009 - Atualização do Ajuste SINIEF 14/2009</xs:documentation>
			<xs:documentation>Tipo CFOP - PL_005d - 11/08/09 - atualizaçãp do Ajuste SINIEF 05/2009</xs:documentation>
			<xs:documentation>Tipo CFOP // 24/10/08 acrescentada a lista de CFOP validos // PL_06 eliminado os CFOP de prestação de serviços de comunicação // PL_006f eliminado os CFOP de prestação de serviços de transporte</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="1101"/>
			<xs:enumeration value="1102"/>
			<xs:enumeration value="1111"/>
			<xs:enumeration value="1113"/>
			<xs:enumeration value="1116"/>
			<xs:enumeration value="1117"/>
			<xs:enumeration value="1118"/>
			<xs:enumeration value="1120"/>
			<xs:enumeration value="1121"/>
			<xs:enumeration value="1122"/>
			<xs:enumeration value="1124"/>
			<xs:enumeration value="1125"/>
			<xs:enumeration value="1126"/>
			<xs:enumeration value="1128"/>
			<xs:enumeration value="1151"/>
			<xs:enumeration value="1152"/>
			<xs:enumeration value="1153"/>
			<xs:enumeration value="1154"/>
			<xs:enumeration value="1201"/>
			<xs:enumeration value="1202"/>
			<xs:enumeration value="1203"/>
			<xs:enumeration value="1204"/>
			<xs:enumeration value="1205"/>
			<xs:enumeration value="1206"/>
			<xs:enumeration value="1207"/>
			<xs:enumeration value="1208"/>
			<xs:enumeration value="1209"/>
			<xs:enumeration value="1251"/>
			<xs:enumeration value="1252"/>
			<xs:enumeration value="1253"/>
			<xs:enumeration value="1254"/>
			<xs:enumeration value="1255"/>
			<xs:enumeration value="1256"/>
			<xs:enumeration value="1257"/>
			<xs:enumeration value="1301"/>
			<xs:enumeration value="1302"/>
			<xs:enumeration value="1303"/>
			<xs:enumeration value="1304"/>
			<xs:enumeration value="1305"/>
			<xs:enumeration value="1306"/>
			<xs:enumeration value="1351"/>
			<xs:enumeration value="1352"/>
			<xs:enumeration value="1353"/>
			<xs:enumeration value="1354"/>
			<xs:enumeration value="1355"/>
			<xs:enumeration value="1356"/>
			<xs:enumeration value="1360"/>
			<xs:enumeration value="1401"/>
			<xs:enumeration value="1403"/>
			<xs:enumeration value="1406"/>
			<xs:enumeration value="1407"/>
			<xs:enumeration value="1408"/>
			<xs:enumeration value="1409"/>
			<xs:enumeration value="1410"/>
			<xs:enumeration value="1411"/>
			<xs:enumeration value="1414"/>
			<xs:enumeration value="1415"/>
			<xs:enumeration value="1451"/>
			<xs:enumeration value="1452"/>
			<xs:enumeration value="1501"/>
			<xs:enumeration value="1503"/>
			<xs:enumeration value="1504"/>
			<xs:enumeration value="1505"/>
			<xs:enumeration value="1506"/>
			<xs:enumeration value="1551"/>
			<xs:enumeration value="1552"/>
			<xs:enumeration value="1553"/>
			<xs:enumeration value="1554"/>
			<xs:enumeration value="1555"/>
			<xs:enumeration value="1556"/>
			<xs:enumeration value="1557"/>
			<xs:enumeration value="1601"/>
			<xs:enumeration value="1602"/>
			<xs:enumeration value="1603"/>
			<xs:enumeration value="1604"/>
			<xs:enumeration value="1605"/>
			<xs:enumeration value="1651"/>
			<xs:enumeration value="1652"/>
			<xs:enumeration value="1653"/>
			<xs:enumeration value="1658"/>
			<xs:enumeration value="1659"/>
			<xs:enumeration value="1660"/>
			<xs:enumeration value="1661"/>
			<xs:enumeration value="1662"/>
			<xs:enumeration value="1663"/>
			<xs:enumeration value="1664"/>
			<xs:enumeration value="1901"/>
			<xs:enumeration value="1902"/>
			<xs:enumeration value="1903"/>
			<xs:enumeration value="1904"/>
			<xs:enumeration value="1905"/>
			<xs:enumeration value="1906"/>
			<xs:enumeration value="1907"/>
			<xs:enumeration value="1908"/>
			<xs:enumeration value="1909"/>
			<xs:enumeration value="1910"/>
			<xs:enumeration value="1911"/>
			<xs:enumeration value="1912"/>
			<xs:enumeration value="1913"/>
			<xs:enumeration value="1914"/>
			<xs:enumeration value="1915"/>
			<xs:enumeration value="1916"/>
			<xs:enumeration value="1917"/>
			<xs:enumeration value="1918"/>
			<xs:enumeration value="1919"/>
			<xs:enumeration value="1920"/>
			<xs:enumeration value="1921"/>
			<xs:enumeration value="1922"/>
			<xs:enumeration value="1923"/>
			<xs:enumeration value="1924"/>
			<xs:enumeration value="1925"/>
			<xs:enumeration value="1926"/>
			<xs:enumeration value="1931"/>
			<xs:enumeration value="1932"/>
			<xs:enumeration value="1933"/>
			<xs:enumeration value="1934"/>
			<xs:enumeration value="1949"/>
			<xs:enumeration value="2101"/>
			<xs:enumeration value="2102"/>
			<xs:enumeration value="2111"/>
			<xs:enumeration value="2113"/>
			<xs:enumeration value="2116"/>
			<xs:enumeration value="2117"/>
			<xs:enumeration value="2118"/>
			<xs:enumeration value="2120"/>
			<xs:enumeration value="2121"/>
			<xs:enumeration value="2122"/>
			<xs:enumeration value="2124"/>
			<xs:enumeration value="2125"/>
			<xs:enumeration value="2126"/>
			<xs:enumeration value="2128"/>
			<xs:enumeration value="2151"/>
			<xs:enumeration value="2152"/>
			<xs:enumeration value="2153"/>
			<xs:enumeration value="2154"/>
			<xs:enumeration value="2201"/>
			<xs:enumeration value="2202"/>
			<xs:enumeration value="2203"/>
			<xs:enumeration value="2204"/>
			<xs:enumeration value="2205"/>
			<xs:enumeration value="2206"/>
			<xs:enumeration value="2207"/>
			<xs:enumeration value="2208"/>
			<xs:enumeration value="2209"/>
			<xs:enumeration value="2251"/>
			<xs:enumeration value="2252"/>
			<xs:enumeration value="2253"/>
			<xs:enumeration value="2254"/>
			<xs:enumeration value="2255"/>
			<xs:enumeration value="2256"/>
			<xs:enumeration value="2257"/>
			<xs:enumeration value="2301"/>
			<xs:enumeration value="2302"/>
			<xs:enumeration value="2303"/>
			<xs:enumeration value="2304"/>
			<xs:enumeration value="2305"/>
			<xs:enumeration value="2306"/>
			<xs:enumeration value="2351"/>
			<xs:enumeration value="2352"/>
			<xs:enumeration value="2353"/>
			<xs:enumeration value="2354"/>
			<xs:enumeration value="2355"/>
			<xs:enumeration value="2356"/>
			<xs:enumeration value="2401"/>
			<xs:enumeration value="2403"/>
			<xs:enumeration value="2406"/>
			<xs:enumeration value="2407"/>
			<xs:enumeration value="2408"/>
			<xs:enumeration value="2409"/>
			<xs:enumeration value="2410"/>
			<xs:enumeration value="2411"/>
			<xs:enumeration value="2414"/>
			<xs:enumeration value="2415"/>
			<xs:enumeration value="2501"/>
			<xs:enumeration value="2503"/>
			<xs:enumeration value="2504"/>
			<xs:enumeration value="2505"/>
			<xs:enumeration value="2506"/>
			<xs:enumeration value="2551"/>
			<xs:enumeration value="2552"/>
			<xs:enumeration value="2553"/>
			<xs:enumeration value="2554"/>
			<xs:enumeration value="2555"/>
			<xs:enumeration value="2556"/>
			<xs:enumeration value="2557"/>
			<xs:enumeration value="2603"/>
			<xs:enumeration value="2651"/>
			<xs:enumeration value="2652"/>
			<xs:enumeration value="2653"/>
			<xs:enumeration value="2658"/>
			<xs:enumeration value="2659"/>
			<xs:enumeration value="2660"/>
			<xs:enumeration value="2661"/>
			<xs:enumeration value="2662"/>
			<xs:enumeration value="2663"/>
			<xs:enumeration value="2664"/>
			<xs:enumeration value="2901"/>
			<xs:enumeration value="2902"/>
			<xs:enumeration value="2903"/>
			<xs:enumeration value="2904"/>
			<xs:enumeration value="2905"/>
			<xs:enumeration value="2906"/>
			<xs:enumeration value="2907"/>
			<xs:enumeration value="2908"/>
			<xs:enumeration value="2909"/>
			<xs:enumeration value="2910"/>
			<xs:enumeration value="2911"/>
			<xs:enumeration value="2912"/>
			<xs:enumeration value="2913"/>
			<xs:enumeration value="2914"/>
			<xs:enumeration value="2915"/>
			<xs:enumeration value="2916"/>
			<xs:enumeration value="2917"/>
			<xs:enumeration value="2918"/>
			<xs:enumeration value="2919"/>
			<xs:enumeration value="2920"/>
			<xs:enumeration value="2921"/>
			<xs:enumeration value="2922"/>
			<xs:enumeration value="2923"/>
			<xs:enumeration value="2924"/>
			<xs:enumeration value="2925"/>
			<xs:enumeration value="2931"/>
			<xs:enumeration value="2932"/>
			<xs:enumeration value="2933"/>
			<xs:enumeration value="2934"/>
			<xs:enumeration value="2949"/>
			<xs:enumeration value="3101"/>
			<xs:enumeration value="3102"/>
			<xs:enumeration value="3126"/>
			<xs:enumeration value="3127"/>
			<xs:enumeration value="3128"/>
			<xs:enumeration value="3201"/>
			<xs:enumeration value="3202"/>
			<xs:enumeration value="3205"/>
			<xs:enumeration value="3206"/>
			<xs:enumeration value="3207"/>
			<xs:enumeration value="3211"/>
			<xs:enumeration value="3251"/>
			<xs:enumeration value="3301"/>
			<xs:enumeration value="3351"/>
			<xs:enumeration value="3352"/>
			<xs:enumeration value="3353"/>
			<xs:enumeration value="3354"/>
			<xs:enumeration value="3355"/>
			<xs:enumeration value="3356"/>
			<xs:enumeration value="3503"/>
			<xs:enumeration value="3551"/>
			<xs:enumeration value="3553"/>
			<xs:enumeration value="3556"/>
			<xs:enumeration value="3651"/>
			<xs:enumeration value="3652"/>
			<xs:enumeration value="3653"/>
			<xs:enumeration value="3930"/>
			<xs:enumeration value="3949"/>
			<xs:enumeration value="5101"/>
			<xs:enumeration value="5102"/>
			<xs:enumeration value="5103"/>
			<xs:enumeration value="5104"/>
			<xs:enumeration value="5105"/>
			<xs:enumeration value="5106"/>
			<xs:enumeration value="5109"/>
			<xs:enumeration value="5110"/>
			<xs:enumeration value="5111"/>
			<xs:enumeration value="5112"/>
			<xs:enumeration value="5113"/>
			<xs:enumeration value="5114"/>
			<xs:enumeration value="5115"/>
			<xs:enumeration value="5116"/>
			<xs:enumeration value="5117"/>
			<xs:enumeration value="5118"/>
			<xs:enumeration value="5119"/>
			<xs:enumeration value="5120"/>
			<xs:enumeration value="5122"/>
			<xs:enumeration value="5123"/>
			<xs:enumeration value="5124"/>
			<xs:enumeration value="5125"/>
			<xs:enumeration value="5151"/>
			<xs:enumeration value="5152"/>
			<xs:enumeration value="5153"/>
			<xs:enumeration value="5155"/>
			<xs:enumeration value="5156"/>
			<xs:enumeration value="5201"/>
			<xs:enumeration value="5202"/>
			<xs:enumeration value="5205"/>
			<xs:enumeration value="5206"/>
			<xs:enumeration value="5207"/>
			<xs:enumeration value="5208"/>
			<xs:enumeration value="5209"/>
			<xs:enumeration value="5210"/>
			<xs:enumeration value="5251"/>
			<xs:enumeration value="5252"/>
			<xs:enumeration value="5253"/>
			<xs:enumeration value="5254"/>
			<xs:enumeration value="5255"/>
			<xs:enumeration value="5256"/>
			<xs:enumeration value="5257"/>
			<xs:enumeration value="5258"/>
			<xs:enumeration value="5401"/>
			<xs:enumeration value="5402"/>
			<xs:enumeration value="5403"/>
			<xs:enumeration value="5405"/>
			<xs:enumeration value="5408"/>
			<xs:enumeration value="5409"/>
			<xs:enumeration value="5410"/>
			<xs:enumeration value="5411"/>
			<xs:enumeration value="5412"/>
			<xs:enumeration value="5413"/>
			<xs:enumeration value="5414"/>
			<xs:enumeration value="5415"/>
			<xs:enumeration value="5451"/>
			<xs:enumeration value="5501"/>
			<xs:enumeration value="5502"/>
			<xs:enumeration value="5503"/>
			<xs:enumeration value="5504"/>
			<xs:enumeration value="5505"/>
			<xs:enumeration value="5551"/>
			<xs:enumeration value="5552"/>
			<xs:enumeration value="5553"/>
			<xs:enumeration value="5554"/>
			<xs:enumeration value="5555"/>
			<xs:enumeration value="5556"/>
			<xs:enumeration value="5557"/>
			<xs:enumeration value="5601"/>
			<xs:enumeration value="5602"/>
			<xs:enumeration value="5603"/>
			<xs:enumeration value="5605"/>
			<xs:enumeration value="5606"/>
			<xs:enumeration value="5651"/>
			<xs:enumeration value="5652"/>
			<xs:enumeration value="5653"/>
			<xs:enumeration value="5654"/>
			<xs:enumeration value="5655"/>
			<xs:enumeration value="5656"/>
			<xs:enumeration value="5657"/>
			<xs:enumeration value="5658"/>
			<xs:enumeration value="5659"/>
			<xs:enumeration value="5660"/>
			<xs:enumeration value="5661"/>
			<xs:enumeration value="5662"/>
			<xs:enumeration value="5663"/>
			<xs:enumeration value="5664"/>
			<xs:enumeration value="5665"/>
			<xs:enumeration value="5666"/>
			<xs:enumeration value="5667"/>
			<xs:enumeration value="5901"/>
			<xs:enumeration value="5902"/>
			<xs:enumeration value="5903"/>
			<xs:enumeration value="5904"/>
			<xs:enumeration value="5905"/>
			<xs:enumeration value="5906"/>
			<xs:enumeration value="5907"/>
			<xs:enumeration value="5908"/>
			<xs:enumeration value="5909"/>
			<xs:enumeration value="5910"/>
			<xs:enumeration value="5911"/>
			<xs:enumeration value="5912"/>
			<xs:enumeration value="5913"/>
			<xs:enumeration value="5914"/>
			<xs:enumeration value="5915"/>
			<xs:enumeration value="5916"/>
			<xs:enumeration value="5917"/>
			<xs:enumeration value="5918"/>
			<xs:enumeration value="5919"/>
			<xs:enumeration value="5920"/>
			<xs:enumeration value="5921"/>
			<xs:enumeration value="5922"/>
			<xs:enumeration value="5923"/>
			<xs:enumeration value="5924"/>
			<xs:enumeration value="5925"/>
			<xs:enumeration value="5926"/>
			<xs:enumeration value="5927"/>
			<xs:enumeration value="5928"/>
			<xs:enumeration value="5929"/>
			<xs:enumeration value="5931"/>
			<xs:enumeration value="5932"/>
			<xs:enumeration value="5933"/>
			<xs:enumeration value="5934"/>
			<xs:enumeration value="5949"/>
			<xs:enumeration value="6101"/>
			<xs:enumeration value="6102"/>
			<xs:enumeration value="6103"/>
			<xs:enumeration value="6104"/>
			<xs:enumeration value="6105"/>
			<xs:enumeration value="6106"/>
			<xs:enumeration value="6107"/>
			<xs:enumeration value="6108"/>
			<xs:enumeration value="6109"/>
			<xs:enumeration value="6110"/>
			<xs:enumeration value="6111"/>
			<xs:enumeration value="6112"/>
			<xs:enumeration value="6113"/>
			<xs:enumeration value="6114"/>
			<xs:enumeration value="6115"/>
			<xs:enumeration value="6116"/>
			<xs:enumeration value="6117"/>
			<xs:enumeration value="6118"/>
			<xs:enumeration value="6119"/>
			<xs:enumeration value="6120"/>
			<xs:enumeration value="6122"/>
			<xs:enumeration value="6123"/>
			<xs:enumeration value="6124"/>
			<xs:enumeration value="6125"/>
			<xs:enumeration value="6151"/>
			<xs:enumeration value="6152"/>
			<xs:enumeration value="6153"/>
			<xs:enumeration value="6155"/>
			<xs:enumeration value="6156"/>
			<xs:enumeration value="6201"/>
			<xs:enumeration value="6202"/>
			<xs:enumeration value="6205"/>
			<xs:enumeration value="6206"/>
			<xs:enumeration value="6207"/>
			<xs:enumeration value="6208"/>
			<xs:enumeration value="6209"/>
			<xs:enumeration value="6210"/>
			<xs:enumeration value="6251"/>
			<xs:enumeration value="6252"/>
			<xs:enumeration value="6253"/>
			<xs:enumeration value="6254"/>
			<xs:enumeration value="6255"/>
			<xs:enumeration value="6256"/>
			<xs:enumeration value="6257"/>
			<xs:enumeration value="6258"/>
			<xs:enumeration value="6401"/>
			<xs:enumeration value="6402"/>
			<xs:enumeration value="6403"/>
			<xs:enumeration value="6404"/>
			<xs:enumeration value="6408"/>
			<xs:enumeration value="6409"/>
			<xs:enumeration value="6410"/>
			<xs:enumeration value="6411"/>
			<xs:enumeration value="6412"/>
			<xs:enumeration value="6413"/>
			<xs:enumeration value="6414"/>
			<xs:enumeration value="6415"/>
			<xs:enumeration value="6501"/>
			<xs:enumeration value="6502"/>
			<xs:enumeration value="6503"/>
			<xs:enumeration value="6504"/>
			<xs:enumeration value="6505"/>
			<xs:enumeration value="6551"/>
			<xs:enumeration value="6552"/>
			<xs:enumeration value="6553"/>
			<xs:enumeration value="6554"/>
			<xs:enumeration value="6555"/>
			<xs:enumeration value="6556"/>
			<xs:enumeration value="6557"/>
			<xs:enumeration value="6603"/>
			<xs:enumeration value="6651"/>
			<xs:enumeration value="6652"/>
			<xs:enumeration value="6653"/>
			<xs:enumeration value="6654"/>
			<xs:enumeration value="6655"/>
			<xs:enumeration value="6656"/>
			<xs:enumeration value="6657"/>
			<xs:enumeration value="6658"/>
			<xs:enumeration value="6659"/>
			<xs:enumeration value="6660"/>
			<xs:enumeration value="6661"/>
			<xs:enumeration value="6662"/>
			<xs:enumeration value="6663"/>
			<xs:enumeration value="6664"/>
			<xs:enumeration value="6665"/>
			<xs:enumeration value="6666"/>
			<xs:enumeration value="6667"/>
			<xs:enumeration value="6901"/>
			<xs:enumeration value="6902"/>
			<xs:enumeration value="6903"/>
			<xs:enumeration value="6904"/>
			<xs:enumeration value="6905"/>
			<xs:enumeration value="6906"/>
			<xs:enumeration value="6907"/>
			<xs:enumeration value="6908"/>
			<xs:enumeration value="6909"/>
			<xs:enumeration value="6910"/>
			<xs:enumeration value="6911"/>
			<xs:enumeration value="6912"/>
			<xs:enumeration value="6913"/>
			<xs:enumeration value="6914"/>
			<xs:enumeration value="6915"/>
			<xs:enumeration value="6916"/>
			<xs:enumeration value="6917"/>
			<xs:enumeration value="6918"/>
			<xs:enumeration value="6919"/>
			<xs:enumeration value="6920"/>
			<xs:enumeration value="6921"/>
			<xs:enumeration value="6922"/>
			<xs:enumeration value="6923"/>
			<xs:enumeration value="6924"/>
			<xs:enumeration value="6925"/>
			<xs:enumeration value="6929"/>
			<xs:enumeration value="6931"/>
			<xs:enumeration value="6932"/>
			<xs:enumeration value="6933"/>
			<xs:enumeration value="6934"/>
			<xs:enumeration value="6949"/>
			<xs:enumeration value="7101"/>
			<xs:enumeration value="7102"/>
			<xs:enumeration value="7105"/>
			<xs:enumeration value="7106"/>
			<xs:enumeration value="7127"/>
			<xs:enumeration value="7201"/>
			<xs:enumeration value="7202"/>
			<xs:enumeration value="7205"/>
			<xs:enumeration value="7206"/>
			<xs:enumeration value="7207"/>
			<xs:enumeration value="7210"/>
			<xs:enumeration value="7211"/>
			<xs:enumeration value="7251"/>
			<xs:enumeration value="7501"/>
			<xs:enumeration value="7551"/>
			<xs:enumeration value="7553"/>
			<xs:enumeration value="7556"/>
			<xs:enumeration value="7651"/>
			<xs:enumeration value="7654"/>
			<xs:enumeration value="7667"/>
			<xs:enumeration value="7930"/>
			<xs:enumeration value="7949"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TcProdANP">
		<xs:annotation>
			<xs:documentation>Código de produto da ANP de acordo com o Sistema de Movimentação de produtos - SIMP</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="110203073"/>
			<xs:enumeration value="110204001"/>
			<xs:enumeration value="110204002"/>
			<xs:enumeration value="140101027"/>
			<xs:enumeration value="140101026"/>
			<xs:enumeration value="740101005"/>
			<xs:enumeration value="740101004"/>
			<xs:enumeration value="740101001"/>
			<xs:enumeration value="740101006"/>
			<xs:enumeration value="740101002"/>
			<xs:enumeration value="110203083"/>
			<xs:enumeration value="910101001"/>
			<xs:enumeration value="110103001"/>
			<xs:enumeration value="330101001"/>
			<xs:enumeration value="110203091"/>
			<xs:enumeration value="120204001"/>
			<xs:enumeration value="110106001"/>
			<xs:enumeration value="120206001"/>
			<xs:enumeration value="110101001"/>
			<xs:enumeration value="110101042"/>
			<xs:enumeration value="810201001"/>
			<xs:enumeration value="110204003"/>
			<xs:enumeration value="330201005"/>
			<xs:enumeration value="330201006"/>
			<xs:enumeration value="330201004"/>
			<xs:enumeration value="110105001"/>
			<xs:enumeration value="110203072"/>
			<xs:enumeration value="110203001"/>
			<xs:enumeration value="110201001"/>
			<xs:enumeration value="110101002"/>
			<xs:enumeration value="110203002"/>
			<xs:enumeration value="120205010"/>
			<xs:enumeration value="110203003"/>
			<xs:enumeration value="110204004"/>
			<xs:enumeration value="110204005"/>
			<xs:enumeration value="110204006"/>
			<xs:enumeration value="110204007"/>
			<xs:enumeration value="110204008"/>
			<xs:enumeration value="110204009"/>
			<xs:enumeration value="110204010"/>
			<xs:enumeration value="110204011"/>
			<xs:enumeration value="110105027"/>
			<xs:enumeration value="110103003"/>
			<xs:enumeration value="110103002"/>
			<xs:enumeration value="110105002"/>
			<xs:enumeration value="110205001"/>
			<xs:enumeration value="120203002"/>
			<xs:enumeration value="120205001"/>
			<xs:enumeration value="110203004"/>
			<xs:enumeration value="120203001"/>
			<xs:enumeration value="530102001"/>
			<xs:enumeration value="530101002"/>
			<xs:enumeration value="110108001"/>
			<xs:enumeration value="110105017"/>
			<xs:enumeration value="110206019"/>
			<xs:enumeration value="110205023"/>
			<xs:enumeration value="110203092"/>
			<xs:enumeration value="110201002"/>
			<xs:enumeration value="120202001"/>
			<xs:enumeration value="110101003"/>
			<xs:enumeration value="110101004"/>
			<xs:enumeration value="110103004"/>
			<xs:enumeration value="110103005"/>
			<xs:enumeration value="110101005"/>
			<xs:enumeration value="110204012"/>
			<xs:enumeration value="110204013"/>
			<xs:enumeration value="110204014"/>
			<xs:enumeration value="110102001"/>
			<xs:enumeration value="120207003"/>
			<xs:enumeration value="110201003"/>
			<xs:enumeration value="110201004"/>
			<xs:enumeration value="110201005"/>
			<xs:enumeration value="110201006"/>
			<xs:enumeration value="110206001"/>
			<xs:enumeration value="110205002"/>
			<xs:enumeration value="110203005"/>
			<xs:enumeration value="110205003"/>
			<xs:enumeration value="330201001"/>
			<xs:enumeration value="110206002"/>
			<xs:enumeration value="110101006"/>
			<xs:enumeration value="110101007"/>
			<xs:enumeration value="110101038"/>
			<xs:enumeration value="120205002"/>
			<xs:enumeration value="820101001"/>
			<xs:enumeration value="820101010"/>
			<xs:enumeration value="820101999"/>
			<xs:enumeration value="110206003"/>
			<xs:enumeration value="110201007"/>
			<xs:enumeration value="120201001"/>
			<xs:enumeration value="110201008"/>
			<xs:enumeration value="110103017"/>
			<xs:enumeration value="110205004"/>
			<xs:enumeration value="110203077"/>
			<xs:enumeration value="110101008"/>
			<xs:enumeration value="110203006"/>
			<xs:enumeration value="110203007"/>
			<xs:enumeration value="110201009"/>
			<xs:enumeration value="110203008"/>
			<xs:enumeration value="110203009"/>
			<xs:enumeration value="110203010"/>
			<xs:enumeration value="120203004"/>
			<xs:enumeration value="110206004"/>
			<xs:enumeration value="610101009"/>
			<xs:enumeration value="120205003"/>
			<xs:enumeration value="110205005"/>
			<xs:enumeration value="110203092"/>
			<xs:enumeration value="110204015"/>
			<xs:enumeration value="210202003"/>
			<xs:enumeration value="210202001"/>
			<xs:enumeration value="210202002"/>
			<xs:enumeration value="110105018"/>
			<xs:enumeration value="110203011"/>
			<xs:enumeration value="110203012"/>
			<xs:enumeration value="110101009"/>
			<xs:enumeration value="110104001"/>
			<xs:enumeration value="110104006"/>
			<xs:enumeration value="110106010"/>
			<xs:enumeration value="110202007"/>
			<xs:enumeration value="110106002"/>
			<xs:enumeration value="110111002"/>
			<xs:enumeration value="110103006"/>
			<xs:enumeration value="110105003"/>
			<xs:enumeration value="110201010"/>
			<xs:enumeration value="110201011"/>
			<xs:enumeration value="110201012"/>
			<xs:enumeration value="110101010"/>
			<xs:enumeration value="110101011"/>
			<xs:enumeration value="110108002"/>
			<xs:enumeration value="110107001"/>
			<xs:enumeration value="120202002"/>
			<xs:enumeration value="110106003"/>
			<xs:enumeration value="110108003"/>
			<xs:enumeration value="110203085"/>
			<xs:enumeration value="110201013"/>
			<xs:enumeration value="110207001"/>
			<xs:enumeration value="110105023"/>
			<xs:enumeration value="110101012"/>
			<xs:enumeration value="110201014"/>
			<xs:enumeration value="620501002"/>
			<xs:enumeration value="620501001"/>
			<xs:enumeration value="610101005"/>
			<xs:enumeration value="610101006"/>
			<xs:enumeration value="530101001"/>
			<xs:enumeration value="530101020"/>
			<xs:enumeration value="530101018"/>
			<xs:enumeration value="110205006"/>
			<xs:enumeration value="110201015"/>
			<xs:enumeration value="110203013"/>
			<xs:enumeration value="110202001"/>
			<xs:enumeration value="120104001"/>
			<xs:enumeration value="120102001"/>
			<xs:enumeration value="110205024"/>
			<xs:enumeration value="120205009"/>
			<xs:enumeration value="540101002"/>
			<xs:enumeration value="540101001"/>
			<xs:enumeration value="110107002"/>
			<xs:enumeration value="620601003"/>
			<xs:enumeration value="110201016"/>
			<xs:enumeration value="110101013"/>
			<xs:enumeration value="120207001"/>
			<xs:enumeration value="110206020"/>
			<xs:enumeration value="110104008"/>
			<xs:enumeration value="110201017"/>
			<xs:enumeration value="110108004"/>
			<xs:enumeration value="110201018"/>
			<xs:enumeration value="330201007"/>
			<xs:enumeration value="110205007"/>
			<xs:enumeration value="110203086"/>
			<xs:enumeration value="110205008"/>
			<xs:enumeration value="340101002"/>
			<xs:enumeration value="130202002"/>
			<xs:enumeration value="430101002"/>
			<xs:enumeration value="130202003"/>
			<xs:enumeration value="560101002"/>
			<xs:enumeration value="130202004"/>
			<xs:enumeration value="820101026"/>
			<xs:enumeration value="820101032"/>
			<xs:enumeration value="820101027"/>
			<xs:enumeration value="820101004"/>
			<xs:enumeration value="820101005"/>
			<xs:enumeration value="820101022"/>
			<xs:enumeration value="820101007"/>
			<xs:enumeration value="820101002"/>
			<xs:enumeration value="820101009"/>
			<xs:enumeration value="820101008"/>
			<xs:enumeration value="820101014"/>
			<xs:enumeration value="820101006"/>
			<xs:enumeration value="820101016"/>
			<xs:enumeration value="820101015"/>
			<xs:enumeration value="820101014"/>
			<xs:enumeration value="820101006"/>
			<xs:enumeration value="820101031"/>
			<xs:enumeration value="820101030"/>
			<xs:enumeration value="820101016"/>
			<xs:enumeration value="820101015"/>
			<xs:enumeration value="820101025"/>
			<xs:enumeration value="820101007"/>
			<xs:enumeration value="820101002"/>
			<xs:enumeration value="820101026"/>
			<xs:enumeration value="820101009"/>
			<xs:enumeration value="820101008"/>
			<xs:enumeration value="820101027"/>
			<xs:enumeration value="820101007"/>
			<xs:enumeration value="820101002"/>
			<xs:enumeration value="820101028"/>
			<xs:enumeration value="820101029"/>
			<xs:enumeration value="820101009"/>
			<xs:enumeration value="820101008"/>
			<xs:enumeration value="820101011"/>
			<xs:enumeration value="820101003"/>
			<xs:enumeration value="820101013"/>
			<xs:enumeration value="820101012"/>
			<xs:enumeration value="820101017"/>
			<xs:enumeration value="820101018"/>
			<xs:enumeration value="820101019"/>
			<xs:enumeration value="820101020"/>
			<xs:enumeration value="820101021"/>
			<xs:enumeration value="330101003"/>
			<xs:enumeration value="130202006"/>
			<xs:enumeration value="110203014"/>
			<xs:enumeration value="420201001"/>
			<xs:enumeration value="420201003"/>
			<xs:enumeration value="120204010"/>
			<xs:enumeration value="110103007"/>
			<xs:enumeration value="110204017"/>
			<xs:enumeration value="110204051"/>
			<xs:enumeration value="110204018"/>
			<xs:enumeration value="110205022"/>
			<xs:enumeration value="110203069"/>
			<xs:enumeration value="110203015"/>
			<xs:enumeration value="110206005"/>
			<xs:enumeration value="110203016"/>
			<xs:enumeration value="110203017"/>
			<xs:enumeration value="110203018"/>
			<xs:enumeration value="110203088"/>
			<xs:enumeration value="110203019"/>
			<xs:enumeration value="530101003"/>
			<xs:enumeration value="530101019"/>
			<xs:enumeration value="110101014"/>
			<xs:enumeration value="620101002"/>
			<xs:enumeration value="720101001"/>
			<xs:enumeration value="720101002"/>
			<xs:enumeration value="120205004"/>
			<xs:enumeration value="110203079"/>
			<xs:enumeration value="110203020"/>
			<xs:enumeration value="110201019"/>
			<xs:enumeration value="110203021"/>
			<xs:enumeration value="110108005"/>
			<xs:enumeration value="110101015"/>
			<xs:enumeration value="110104002"/>
			<xs:enumeration value="110101016"/>
			<xs:enumeration value="620101007"/>
			<xs:enumeration value="140102001"/>
			<xs:enumeration value="110105004"/>
			<xs:enumeration value="110107003"/>
			<xs:enumeration value="110203095"/>
			<xs:enumeration value="210301001"/>
			<xs:enumeration value="810102001"/>
			<xs:enumeration value="810102004"/>
			<xs:enumeration value="810102002"/>
			<xs:enumeration value="130201002"/>
			<xs:enumeration value="810102003"/>
			<xs:enumeration value="810101002"/>
			<xs:enumeration value="810101001"/>
			<xs:enumeration value="810101003"/>
			<xs:enumeration value="210301002"/>
			<xs:enumeration value="330201010"/>
			<xs:enumeration value="110204016"/>
			<xs:enumeration value="110105005"/>
			<xs:enumeration value="110105006"/>
			<xs:enumeration value="110105007"/>
			<xs:enumeration value="110104003"/>
			<xs:enumeration value="110206006"/>
			<xs:enumeration value="110206007"/>
			<xs:enumeration value="110203022"/>
			<xs:enumeration value="110204019"/>
			<xs:enumeration value="110206008"/>
			<xs:enumeration value="110206009"/>
			<xs:enumeration value="110101043"/>
			<xs:enumeration value="110201020"/>
			<xs:enumeration value="110203023"/>
			<xs:enumeration value="110101017"/>
			<xs:enumeration value="110101018"/>
			<xs:enumeration value="210302004"/>
			<xs:enumeration value="210101001"/>
			<xs:enumeration value="210302003"/>
			<xs:enumeration value="210302002"/>
			<xs:enumeration value="210204001"/>
			<xs:enumeration value="220101003"/>
			<xs:enumeration value="220101004"/>
			<xs:enumeration value="220101002"/>
			<xs:enumeration value="220101001"/>
			<xs:enumeration value="220101005"/>
			<xs:enumeration value="220101006"/>
			<xs:enumeration value="130202001"/>
			<xs:enumeration value="130202005"/>
			<xs:enumeration value="520101001"/>
			<xs:enumeration value="320101001"/>
			<xs:enumeration value="320101003"/>
			<xs:enumeration value="320101002"/>
			<xs:enumeration value="320103001"/>
			<xs:enumeration value="320102002"/>
			<xs:enumeration value="320102001"/>
			<xs:enumeration value="320102004"/>
			<xs:enumeration value="320102003"/>
			<xs:enumeration value="320201001"/>
			<xs:enumeration value="320201002"/>
			<xs:enumeration value="220102001"/>
			<xs:enumeration value="320301002"/>
			<xs:enumeration value="110204020"/>
			<xs:enumeration value="110203024"/>
			<xs:enumeration value="120205012"/>
			<xs:enumeration value="110207002"/>
			<xs:enumeration value="110203087"/>
			<xs:enumeration value="730101002"/>
			<xs:enumeration value="210203001"/>
			<xs:enumeration value="210203002"/>
			<xs:enumeration value="110104005"/>
			<xs:enumeration value="140101023"/>
			<xs:enumeration value="140101024"/>
			<xs:enumeration value="140101025"/>
			<xs:enumeration value="650101001"/>
			<xs:enumeration value="110207003"/>
			<xs:enumeration value="110201021"/>
			<xs:enumeration value="110103013"/>
			<xs:enumeration value="110201022"/>
			<xs:enumeration value="110203025"/>
			<xs:enumeration value="110203026"/>
			<xs:enumeration value="110206011"/>
			<xs:enumeration value="110206010"/>
			<xs:enumeration value="110203027"/>
			<xs:enumeration value="110203028"/>
			<xs:enumeration value="110203028"/>
			<xs:enumeration value="330101008"/>
			<xs:enumeration value="330101002"/>
			<xs:enumeration value="330101009"/>
			<xs:enumeration value="620101001"/>
			<xs:enumeration value="610201001"/>
			<xs:enumeration value="610201002"/>
			<xs:enumeration value="610201003"/>
			<xs:enumeration value="710101001"/>
			<xs:enumeration value="110203074"/>
			<xs:enumeration value="110201023"/>
			<xs:enumeration value="110103008"/>
			<xs:enumeration value="110203029"/>
			<xs:enumeration value="120205005"/>
			<xs:enumeration value="110204021"/>
			<xs:enumeration value="110204022"/>
			<xs:enumeration value="110204023"/>
			<xs:enumeration value="620101004"/>
			<xs:enumeration value="620101005"/>
			<xs:enumeration value="330101010"/>
			<xs:enumeration value="110202002"/>
			<xs:enumeration value="110202003"/>
			<xs:enumeration value="110207004"/>
			<xs:enumeration value="110101046"/>
			<xs:enumeration value="110204024"/>
			<xs:enumeration value="110113001"/>
			<xs:enumeration value="110105015"/>
			<xs:enumeration value="110101019"/>
			<xs:enumeration value="110103015"/>
			<xs:enumeration value="110205025"/>
			<xs:enumeration value="110204025"/>
			<xs:enumeration value="110204026"/>
			<xs:enumeration value="110204027"/>
			<xs:enumeration value="120204009"/>
			<xs:enumeration value="110205026"/>
			<xs:enumeration value="110204028"/>
			<xs:enumeration value="110204029"/>
			<xs:enumeration value="110203080"/>
			<xs:enumeration value="120207004"/>
			<xs:enumeration value="110203030"/>
			<xs:enumeration value="110105025"/>
			<xs:enumeration value="110203031"/>
			<xs:enumeration value="110203084"/>
			<xs:enumeration value="110203032"/>
			<xs:enumeration value="110204030"/>
			<xs:enumeration value="110205009"/>
			<xs:enumeration value="110104004"/>
			<xs:enumeration value="110201024"/>
			<xs:enumeration value="110201025"/>
			<xs:enumeration value="110201026"/>
			<xs:enumeration value="110201027"/>
			<xs:enumeration value="110201028"/>
			<xs:enumeration value="110201029"/>
			<xs:enumeration value="110201030"/>
			<xs:enumeration value="110207005"/>
			<xs:enumeration value="110204031"/>
			<xs:enumeration value="110207006"/>
			<xs:enumeration value="110201031"/>
			<xs:enumeration value="110201032"/>
			<xs:enumeration value="110201033"/>
			<xs:enumeration value="120204002"/>
			<xs:enumeration value="110101020"/>
			<xs:enumeration value="220102002"/>
			<xs:enumeration value="110105008"/>
			<xs:enumeration value="110203033"/>
			<xs:enumeration value="110105009"/>
			<xs:enumeration value="110201034"/>
			<xs:enumeration value="110203034"/>
			<xs:enumeration value="110203035"/>
			<xs:enumeration value="640201001"/>
			<xs:enumeration value="120205011"/>
			<xs:enumeration value="110101021"/>
			<xs:enumeration value="120103001"/>
			<xs:enumeration value="110203036"/>
			<xs:enumeration value="120204003"/>
			<xs:enumeration value="110201035"/>
			<xs:enumeration value="110204032"/>
			<xs:enumeration value="110101022"/>
			<xs:enumeration value="110201036"/>
			<xs:enumeration value="110101023"/>
			<xs:enumeration value="110101024"/>
			<xs:enumeration value="110101025"/>
			<xs:enumeration value="110101039"/>
			<xs:enumeration value="110204033"/>
			<xs:enumeration value="120207002"/>
			<xs:enumeration value="110202004"/>
			<xs:enumeration value="110202005"/>
			<xs:enumeration value="110203037"/>
			<xs:enumeration value="110203037"/>
			<xs:enumeration value="110201037"/>
			<xs:enumeration value="110203078"/>
			<xs:enumeration value="120203005"/>
			<xs:enumeration value="120204010"/>
			<xs:enumeration value="110201038"/>
			<xs:enumeration value="110201039"/>
			<xs:enumeration value="120101001"/>
			<xs:enumeration value="110201040"/>
			<xs:enumeration value="110201041"/>
			<xs:enumeration value="740101007"/>
			<xs:enumeration value="420201003"/>
			<xs:enumeration value="640101001"/>
			<xs:enumeration value="110205027"/>
			<xs:enumeration value="110103009"/>
			<xs:enumeration value="110103010"/>
			<xs:enumeration value="110205010"/>
			<xs:enumeration value="820101018"/>
			<xs:enumeration value="820101017"/>
			<xs:enumeration value="820101006"/>
			<xs:enumeration value="820101014"/>
			<xs:enumeration value="820101006"/>
			<xs:enumeration value="820101016"/>
			<xs:enumeration value="820101015"/>
			<xs:enumeration value="820101006"/>
			<xs:enumeration value="820101005"/>
			<xs:enumeration value="820101004"/>
			<xs:enumeration value="820101003"/>
			<xs:enumeration value="820101011"/>
			<xs:enumeration value="820101003"/>
			<xs:enumeration value="820101013"/>
			<xs:enumeration value="820101012"/>
			<xs:enumeration value="820101002"/>
			<xs:enumeration value="820101007"/>
			<xs:enumeration value="820101002"/>
			<xs:enumeration value="820101009"/>
			<xs:enumeration value="820101008"/>
			<xs:enumeration value="110301001"/>
			<xs:enumeration value="110208001"/>
			<xs:enumeration value="110203038"/>
			<xs:enumeration value="110203089"/>
			<xs:enumeration value="110201042"/>
			<xs:enumeration value="110101026"/>
			<xs:enumeration value="620502001"/>
			<xs:enumeration value="110203039"/>
			<xs:enumeration value="110202008"/>
			<xs:enumeration value="110204034"/>
			<xs:enumeration value="110110001"/>
			<xs:enumeration value="310102001"/>
			<xs:enumeration value="310103001"/>
			<xs:enumeration value="310101001"/>
			<xs:enumeration value="110101027"/>
			<xs:enumeration value="110205011"/>
			<xs:enumeration value="110201062"/>
			<xs:enumeration value="110203040"/>
			<xs:enumeration value="610101002"/>
			<xs:enumeration value="610401002"/>
			<xs:enumeration value="610101003"/>
			<xs:enumeration value="610401003"/>
			<xs:enumeration value="610101004"/>
			<xs:enumeration value="610401004"/>
			<xs:enumeration value="110203041"/>
			<xs:enumeration value="110203042"/>
			<xs:enumeration value="110203043"/>
			<xs:enumeration value="110203094"/>
			<xs:enumeration value="110203044"/>
			<xs:enumeration value="110203044"/>
			<xs:enumeration value="430101001"/>
			<xs:enumeration value="110206021"/>
			<xs:enumeration value="120204004"/>
			<xs:enumeration value="110207007"/>
			<xs:enumeration value="110203045"/>
			<xs:enumeration value="110201043"/>
			<xs:enumeration value="110203046"/>
			<xs:enumeration value="110203047"/>
			<xs:enumeration value="110203048"/>
			<xs:enumeration value="110203081"/>
			<xs:enumeration value="430101004"/>
			<xs:enumeration value="510101003"/>
			<xs:enumeration value="510101001"/>
			<xs:enumeration value="510101002"/>
			<xs:enumeration value="510102003"/>
			<xs:enumeration value="510102001"/>
			<xs:enumeration value="510102002"/>
			<xs:enumeration value="510201001"/>
			<xs:enumeration value="510201002"/>
			<xs:enumeration value="510201003"/>
			<xs:enumeration value="510301003"/>
			<xs:enumeration value="140101015"/>
			<xs:enumeration value="140101009"/>
			<xs:enumeration value="140101016"/>
			<xs:enumeration value="140101017"/>
			<xs:enumeration value="140101005"/>
			<xs:enumeration value="140101014"/>
			<xs:enumeration value="140101018"/>
			<xs:enumeration value="140101006"/>
			<xs:enumeration value="140101028"/>
			<xs:enumeration value="140101021"/>
			<xs:enumeration value="140101010"/>
			<xs:enumeration value="140101012"/>
			<xs:enumeration value="140101013"/>
			<xs:enumeration value="140101001"/>
			<xs:enumeration value="140101011"/>
			<xs:enumeration value="140101003"/>
			<xs:enumeration value="140101002"/>
			<xs:enumeration value="140101008"/>
			<xs:enumeration value="140101007"/>
			<xs:enumeration value="140101019"/>
			<xs:enumeration value="140101004"/>
			<xs:enumeration value="560101001"/>
			<xs:enumeration value="420105001"/>
			<xs:enumeration value="420101005"/>
			<xs:enumeration value="420101004"/>
			<xs:enumeration value="420101003"/>
			<xs:enumeration value="420102006"/>
			<xs:enumeration value="420102005"/>
			<xs:enumeration value="420102004"/>
			<xs:enumeration value="420102003"/>
			<xs:enumeration value="420104001"/>
			<xs:enumeration value="820101033"/>
			<xs:enumeration value="820101034"/>
			<xs:enumeration value="820101011"/>
			<xs:enumeration value="820101003"/>
			<xs:enumeration value="820101028"/>
			<xs:enumeration value="820101029"/>
			<xs:enumeration value="820101013"/>
			<xs:enumeration value="820101012"/>
			<xs:enumeration value="420301003"/>
			<xs:enumeration value="420101005"/>
			<xs:enumeration value="420101002"/>
			<xs:enumeration value="420101001"/>
			<xs:enumeration value="420101003"/>
			<xs:enumeration value="420101004"/>
			<xs:enumeration value="420101003"/>
			<xs:enumeration value="420201001"/>
			<xs:enumeration value="420201002"/>
			<xs:enumeration value="420102005"/>
			<xs:enumeration value="420102004"/>
			<xs:enumeration value="420102002"/>
			<xs:enumeration value="420102001"/>
			<xs:enumeration value="420102003"/>
			<xs:enumeration value="420102003"/>
			<xs:enumeration value="420202001"/>
			<xs:enumeration value="420301001"/>
			<xs:enumeration value="420102006"/>
			<xs:enumeration value="420103002"/>
			<xs:enumeration value="420103001"/>
			<xs:enumeration value="420103003"/>
			<xs:enumeration value="610601001"/>
			<xs:enumeration value="610701001"/>
			<xs:enumeration value="510301002"/>
			<xs:enumeration value="620601001"/>
			<xs:enumeration value="660101001"/>
			<xs:enumeration value="620401001"/>
			<xs:enumeration value="620301001"/>
			<xs:enumeration value="620201001"/>
			<xs:enumeration value="630101001"/>
			<xs:enumeration value="110202006"/>
			<xs:enumeration value="110203093"/>
			<xs:enumeration value="110204035"/>
			<xs:enumeration value="110203049"/>
			<xs:enumeration value="110201044"/>
			<xs:enumeration value="110201045"/>
			<xs:enumeration value="110206012"/>
			<xs:enumeration value="120203003"/>
			<xs:enumeration value="320301001"/>
			<xs:enumeration value="320103002"/>
			<xs:enumeration value="650101002"/>
			<xs:enumeration value="310102002"/>
			<xs:enumeration value="640401001"/>
			<xs:enumeration value="140101029"/>
			<xs:enumeration value="740101003"/>
			<xs:enumeration value="810201002"/>
			<xs:enumeration value="530103001"/>
			<xs:enumeration value="340101003"/>
			<xs:enumeration value="430101003"/>
			<xs:enumeration value="560101003"/>
			<xs:enumeration value="210302001"/>
			<xs:enumeration value="210204002"/>
			<xs:enumeration value="130201001"/>
			<xs:enumeration value="530104001"/>
			<xs:enumeration value="140101022"/>
			<xs:enumeration value="140101999"/>
			<xs:enumeration value="610201004"/>
			<xs:enumeration value="510301001"/>
			<xs:enumeration value="420301002"/>
			<xs:enumeration value="620601004"/>
			<xs:enumeration value="620505001"/>
			<xs:enumeration value="610501001"/>
			<xs:enumeration value="620101008"/>
			<xs:enumeration value="610101010"/>
			<xs:enumeration value="110208002"/>
			<xs:enumeration value="110110002"/>
			<xs:enumeration value="130202008"/>
			<xs:enumeration value="410103001"/>
			<xs:enumeration value="610301002"/>
			<xs:enumeration value="610302001"/>
			<xs:enumeration value="330101007"/>
			<xs:enumeration value="330201009"/>
			<xs:enumeration value="730101001"/>
			<xs:enumeration value="110203050"/>
			<xs:enumeration value="110101028"/>
			<xs:enumeration value="110101049"/>
			<xs:enumeration value="110101029"/>
			<xs:enumeration value="110101030"/>
			<xs:enumeration value="110104007"/>
			<xs:enumeration value="110111001"/>
			<xs:enumeration value="120205006"/>
			<xs:enumeration value="110203051"/>
			<xs:enumeration value="110101050"/>
			<xs:enumeration value="110105028"/>
			<xs:enumeration value="110105016"/>
			<xs:enumeration value="110201046"/>
			<xs:enumeration value="110106007"/>
			<xs:enumeration value="110101031"/>
			<xs:enumeration value="110203082"/>
			<xs:enumeration value="610301001"/>
			<xs:enumeration value="110101032"/>
			<xs:enumeration value="110101047"/>
			<xs:enumeration value="110105021"/>
			<xs:enumeration value="110105010"/>
			<xs:enumeration value="620101003"/>
			<xs:enumeration value="210201001"/>
			<xs:enumeration value="210201002"/>
			<xs:enumeration value="210201003"/>
			<xs:enumeration value="110105020"/>
			<xs:enumeration value="110105022"/>
			<xs:enumeration value="110205012"/>
			<xs:enumeration value="620601002"/>
			<xs:enumeration value="120206003"/>
			<xs:enumeration value="110204036"/>
			<xs:enumeration value="110204037"/>
			<xs:enumeration value="110204038"/>
			<xs:enumeration value="410101001"/>
			<xs:enumeration value="410101002"/>
			<xs:enumeration value="410102001"/>
			<xs:enumeration value="410102002"/>
			<xs:enumeration value="110103014"/>
			<xs:enumeration value="110203052"/>
			<xs:enumeration value="330101005"/>
			<xs:enumeration value="330101006"/>
			<xs:enumeration value="110205029"/>
			<xs:enumeration value="110203053"/>
			<xs:enumeration value="120204008"/>
			<xs:enumeration value="110203054"/>
			<xs:enumeration value="110204039"/>
			<xs:enumeration value="110201047"/>
			<xs:enumeration value="110201048"/>
			<xs:enumeration value="110103011"/>
			<xs:enumeration value="340101001"/>
			<xs:enumeration value="550101001"/>
			<xs:enumeration value="550101005"/>
			<xs:enumeration value="550101002"/>
			<xs:enumeration value="550101003"/>
			<xs:enumeration value="550101004"/>
			<xs:enumeration value="130202007"/>
			<xs:enumeration value="110105011"/>
			<xs:enumeration value="110201049"/>
			<xs:enumeration value="110101048"/>
			<xs:enumeration value="110101033"/>
			<xs:enumeration value="110101040"/>
			<xs:enumeration value="110101045"/>
			<xs:enumeration value="110101041"/>
			<xs:enumeration value="110204040"/>
			<xs:enumeration value="110105019"/>
			<xs:enumeration value="110204041"/>
			<xs:enumeration value="110105024"/>
			<xs:enumeration value="110203070"/>
			<xs:enumeration value="110203055"/>
			<xs:enumeration value="110204042"/>
			<xs:enumeration value="110203075"/>
			<xs:enumeration value="110201050"/>
			<xs:enumeration value="110201051"/>
			<xs:enumeration value="110201052"/>
			<xs:enumeration value="110201053"/>
			<xs:enumeration value="120201002"/>
			<xs:enumeration value="110105029"/>
			<xs:enumeration value="110203056"/>
			<xs:enumeration value="110204043"/>
			<xs:enumeration value="110203090"/>
			<xs:enumeration value="140101020"/>
			<xs:enumeration value="110103018"/>
			<xs:enumeration value="110106004"/>
			<xs:enumeration value="110106005"/>
			<xs:enumeration value="110106006"/>
			<xs:enumeration value="110205028"/>
			<xs:enumeration value="110105012"/>
			<xs:enumeration value="120204005"/>
			<xs:enumeration value="110205013"/>
			<xs:enumeration value="110201054"/>
			<xs:enumeration value="110101044"/>
			<xs:enumeration value="110204044"/>
			<xs:enumeration value="110203057"/>
			<xs:enumeration value="110203058"/>
			<xs:enumeration value="120206002"/>
			<xs:enumeration value="120206004"/>
			<xs:enumeration value="330201008"/>
			<xs:enumeration value="330101004"/>
			<xs:enumeration value="110204045"/>
			<xs:enumeration value="110204046"/>
			<xs:enumeration value="110201063"/>
			<xs:enumeration value="110206013"/>
			<xs:enumeration value="110203059"/>
			<xs:enumeration value="110203060"/>
			<xs:enumeration value="610101001"/>
			<xs:enumeration value="610401001"/>
			<xs:enumeration value="110206015"/>
			<xs:enumeration value="110206014"/>
			<xs:enumeration value="110204052"/>
			<xs:enumeration value="110205015"/>
			<xs:enumeration value="110205014"/>
			<xs:enumeration value="110204047"/>
			<xs:enumeration value="110205016"/>
			<xs:enumeration value="110203061"/>
			<xs:enumeration value="110205017"/>
			<xs:enumeration value="110106009"/>
			<xs:enumeration value="110203062"/>
			<xs:enumeration value="110206016"/>
			<xs:enumeration value="120205007"/>
			<xs:enumeration value="120201003"/>
			<xs:enumeration value="620101006"/>
			<xs:enumeration value="120205008"/>
			<xs:enumeration value="120204006"/>
			<xs:enumeration value="110201055"/>
			<xs:enumeration value="110201056"/>
			<xs:enumeration value="110201057"/>
			<xs:enumeration value="110103016"/>
			<xs:enumeration value="110205018"/>
			<xs:enumeration value="110107005"/>
			<xs:enumeration value="330201002"/>
			<xs:enumeration value="620504001"/>
			<xs:enumeration value="620503001"/>
			<xs:enumeration value="110101034"/>
			<xs:enumeration value="110107004"/>
			<xs:enumeration value="610101007"/>
			<xs:enumeration value="610101008"/>
			<xs:enumeration value="110105014"/>
			<xs:enumeration value="110205019"/>
			<xs:enumeration value="110103012"/>
			<xs:enumeration value="110203063"/>
			<xs:enumeration value="120204007"/>
			<xs:enumeration value="110204048"/>
			<xs:enumeration value="110105013"/>
			<xs:enumeration value="110204049"/>
			<xs:enumeration value="110206017"/>
			<xs:enumeration value="110109001"/>
			<xs:enumeration value="110107006"/>
			<xs:enumeration value="110201059"/>
			<xs:enumeration value="110201058"/>
			<xs:enumeration value="640301001"/>
			<xs:enumeration value="110101035"/>
			<xs:enumeration value="110101036"/>
			<xs:enumeration value="110101037"/>
			<xs:enumeration value="110205020"/>
			<xs:enumeration value="120207005"/>
			<xs:enumeration value="110206018"/>
			<xs:enumeration value="110108006"/>
			<xs:enumeration value="110203076"/>
			<xs:enumeration value="110205021"/>
			<xs:enumeration value="330201003"/>
			<xs:enumeration value="130101001"/>
			<xs:enumeration value="110201060"/>
			<xs:enumeration value="110203071"/>
			<xs:enumeration value="110203065"/>
			<xs:enumeration value="110203064"/>
			<xs:enumeration value="110204050"/>
			<xs:enumeration value="110203066"/>
			<xs:enumeration value="110203067"/>
			<xs:enumeration value="110201061"/>
			<xs:enumeration value="110203068"/>
			<xs:enumeration value="110105026"/>
			<xs:enumeration value="110106008"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TCfopTransp">
		<xs:annotation>
			<xs:documentation>Tipo CFOP - Transportes - uso exclusivo na retenção - 31/05/2010
			Acrescimo dos CFOP de 5931/5932/6931/6932 no CFOP de retTransp
</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="5351"/>
			<xs:enumeration value="5352"/>
			<xs:enumeration value="5353"/>
			<xs:enumeration value="5354"/>
			<xs:enumeration value="5355"/>
			<xs:enumeration value="5356"/>
			<xs:enumeration value="5357"/>
			<xs:enumeration value="5359"/>
			<xs:enumeration value="5360"/>
			<xs:enumeration value="5931"/>
			<xs:enumeration value="5932"/>
			<xs:enumeration value="6351"/>
			<xs:enumeration value="6352"/>
			<xs:enumeration value="6353"/>
			<xs:enumeration value="6354"/>
			<xs:enumeration value="6355"/>
			<xs:enumeration value="6356"/>
			<xs:enumeration value="6357"/>
			<xs:enumeration value="6359"/>
			<xs:enumeration value="6360"/>
			<xs:enumeration value="6931"/>
			<xs:enumeration value="6932"/>
			<xs:enumeration value="7358"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="Torig">
		<xs:annotation>
			<xs:documentation>Tipo Origem da mercadoria CST ICMS. origem da mercadoria: 0-Nacional 
1-Estrangeira - Importação direta; 2-Estrangeira - Adquirida no mercado interno; 3-Nacional, conteudo superior 40%; 4-Nacional, processos produtivos 
básicos; 5-Nacional, conteudo inferior 40%; 6-Estrangeira - Importação direta, com similar nacional, lista CAMEX; 7-Estrangeira - mercado interno, sem simular,
lista CAMEX. </xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="0"/>
			<xs:enumeration value="1"/>
			<xs:enumeration value="2"/>
			<xs:enumeration value="3"/>
			<xs:enumeration value="4"/>
			<xs:enumeration value="5"/>
			<xs:enumeration value="6"/>
			<xs:enumeration value="7"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TCListServ">
		<xs:annotation>
			<xs:documentation>Tipo Código da Lista de Serviços LC 116/2003</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="101"/>
			<xs:enumeration value="102"/>
			<xs:enumeration value="103"/>
			<xs:enumeration value="104"/>
			<xs:enumeration value="105"/>
			<xs:enumeration value="106"/>
			<xs:enumeration value="107"/>
			<xs:enumeration value="108"/>
			<xs:enumeration value="201"/>
			<xs:enumeration value="302"/>
			<xs:enumeration value="303"/>
			<xs:enumeration value="304"/>
			<xs:enumeration value="305"/>
			<xs:enumeration value="401"/>
			<xs:enumeration value="402"/>
			<xs:enumeration value="403"/>
			<xs:enumeration value="404"/>
			<xs:enumeration value="405"/>
			<xs:enumeration value="406"/>
			<xs:enumeration value="407"/>
			<xs:enumeration value="408"/>
			<xs:enumeration value="409"/>
			<xs:enumeration value="410"/>
			<xs:enumeration value="411"/>
			<xs:enumeration value="412"/>
			<xs:enumeration value="413"/>
			<xs:enumeration value="414"/>
			<xs:enumeration value="415"/>
			<xs:enumeration value="416"/>
			<xs:enumeration value="417"/>
			<xs:enumeration value="418"/>
			<xs:enumeration value="419"/>
			<xs:enumeration value="420"/>
			<xs:enumeration value="421"/>
			<xs:enumeration value="422"/>
			<xs:enumeration value="423"/>
			<xs:enumeration value="501"/>
			<xs:enumeration value="502"/>
			<xs:enumeration value="503"/>
			<xs:enumeration value="504"/>
			<xs:enumeration value="505"/>
			<xs:enumeration value="506"/>
			<xs:enumeration value="507"/>
			<xs:enumeration value="508"/>
			<xs:enumeration value="509"/>
			<xs:enumeration value="601"/>
			<xs:enumeration value="602"/>
			<xs:enumeration value="603"/>
			<xs:enumeration value="604"/>
			<xs:enumeration value="605"/>
			<xs:enumeration value="701"/>
			<xs:enumeration value="702"/>
			<xs:enumeration value="703"/>
			<xs:enumeration value="704"/>
			<xs:enumeration value="705"/>
			<xs:enumeration value="706"/>
			<xs:enumeration value="707"/>
			<xs:enumeration value="708"/>
			<xs:enumeration value="709"/>
			<xs:enumeration value="710"/>
			<xs:enumeration value="711"/>
			<xs:enumeration value="712"/>
			<xs:enumeration value="713"/>
			<xs:enumeration value="716"/>
			<xs:enumeration value="717"/>
			<xs:enumeration value="718"/>
			<xs:enumeration value="719"/>
			<xs:enumeration value="720"/>
			<xs:enumeration value="721"/>
			<xs:enumeration value="722"/>
			<xs:enumeration value="801"/>
			<xs:enumeration value="802"/>
			<xs:enumeration value="901"/>
			<xs:enumeration value="902"/>
			<xs:enumeration value="903"/>
			<xs:enumeration value="1001"/>
			<xs:enumeration value="1002"/>
			<xs:enumeration value="1003"/>
			<xs:enumeration value="1004"/>
			<xs:enumeration value="1005"/>
			<xs:enumeration value="1006"/>
			<xs:enumeration value="1007"/>
			<xs:enumeration value="1008"/>
			<xs:enumeration value="1009"/>
			<xs:enumeration value="1010"/>
			<xs:enumeration value="1101"/>
			<xs:enumeration value="1102"/>
			<xs:enumeration value="1103"/>
			<xs:enumeration value="1104"/>
			<xs:enumeration value="1201"/>
			<xs:enumeration value="1202"/>
			<xs:enumeration value="1203"/>
			<xs:enumeration value="1204"/>
			<xs:enumeration value="1205"/>
			<xs:enumeration value="1206"/>
			<xs:enumeration value="1207"/>
			<xs:enumeration value="1208"/>
			<xs:enumeration value="1209"/>
			<xs:enumeration value="1210"/>
			<xs:enumeration value="1211"/>
			<xs:enumeration value="1212"/>
			<xs:enumeration value="1213"/>
			<xs:enumeration value="1214"/>
			<xs:enumeration value="1215"/>
			<xs:enumeration value="1216"/>
			<xs:enumeration value="1217"/>
			<xs:enumeration value="1302"/>
			<xs:enumeration value="1303"/>
			<xs:enumeration value="1304"/>
			<xs:enumeration value="1305"/>
			<xs:enumeration value="1401"/>
			<xs:enumeration value="1402"/>
			<xs:enumeration value="1403"/>
			<xs:enumeration value="1404"/>
			<xs:enumeration value="1405"/>
			<xs:enumeration value="1406"/>
			<xs:enumeration value="1407"/>
			<xs:enumeration value="1408"/>
			<xs:enumeration value="1409"/>
			<xs:enumeration value="1410"/>
			<xs:enumeration value="1411"/>
			<xs:enumeration value="1412"/>
			<xs:enumeration value="1413"/>
			<xs:enumeration value="1501"/>
			<xs:enumeration value="1502"/>
			<xs:enumeration value="1503"/>
			<xs:enumeration value="1504"/>
			<xs:enumeration value="1505"/>
			<xs:enumeration value="1506"/>
			<xs:enumeration value="1507"/>
			<xs:enumeration value="1508"/>
			<xs:enumeration value="1509"/>
			<xs:enumeration value="1510"/>
			<xs:enumeration value="1511"/>
			<xs:enumeration value="1512"/>
			<xs:enumeration value="1513"/>
			<xs:enumeration value="1514"/>
			<xs:enumeration value="1515"/>
			<xs:enumeration value="1516"/>
			<xs:enumeration value="1517"/>
			<xs:enumeration value="1518"/>
			<xs:enumeration value="1601"/>
			<xs:enumeration value="1701"/>
			<xs:enumeration value="1702"/>
			<xs:enumeration value="1703"/>
			<xs:enumeration value="1704"/>
			<xs:enumeration value="1705"/>
			<xs:enumeration value="1706"/>
			<xs:enumeration value="1708"/>
			<xs:enumeration value="1709"/>
			<xs:enumeration value="1710"/>
			<xs:enumeration value="1711"/>
			<xs:enumeration value="1712"/>
			<xs:enumeration value="1713"/>
			<xs:enumeration value="1714"/>
			<xs:enumeration value="1715"/>
			<xs:enumeration value="1716"/>
			<xs:enumeration value="1717"/>
			<xs:enumeration value="1718"/>
			<xs:enumeration value="1719"/>
			<xs:enumeration value="1720"/>
			<xs:enumeration value="1721"/>
			<xs:enumeration value="1722"/>
			<xs:enumeration value="1723"/>
			<xs:enumeration value="1724"/>
			<xs:enumeration value="1801"/>
			<xs:enumeration value="1901"/>
			<xs:enumeration value="2001"/>
			<xs:enumeration value="2002"/>
			<xs:enumeration value="2003"/>
			<xs:enumeration value="2101"/>
			<xs:enumeration value="2201"/>
			<xs:enumeration value="2301"/>
			<xs:enumeration value="2401"/>
			<xs:enumeration value="2501"/>
			<xs:enumeration value="2502"/>
			<xs:enumeration value="2503"/>
			<xs:enumeration value="2504"/>
			<xs:enumeration value="2601"/>
			<xs:enumeration value="2701"/>
			<xs:enumeration value="2801"/>
			<xs:enumeration value="2901"/>
			<xs:enumeration value="3001"/>
			<xs:enumeration value="3101"/>
			<xs:enumeration value="3201"/>
			<xs:enumeration value="3301"/>
			<xs:enumeration value="3401"/>
			<xs:enumeration value="3501"/>
			<xs:enumeration value="3601"/>
			<xs:enumeration value="3701"/>
			<xs:enumeration value="3801"/>
			<xs:enumeration value="3901"/>
			<xs:enumeration value="4001"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TFinNFe">
		<xs:annotation>
			<xs:documentation>Tipo Finalidade da NF-e</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="1"/>
			<xs:enumeration value="2"/>
			<xs:enumeration value="3"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TProcEmi">
		<xs:annotation>
			<xs:documentation>Tipo processo de emissão da NF-e</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:enumeration value="0"/>
			<xs:enumeration value="1"/>
			<xs:enumeration value="2"/>
			<xs:enumeration value="3"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TVerNFe">
		<xs:annotation>
			<xs:documentation> Tipo Versão da NF-e - 2.00</xs:documentation>
		</xs:annotation>
		<xs:restriction base="xs:string">
			<xs:whiteSpace value="preserve"/>
			<xs:pattern value="2\.00"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:complexType name="TNfeProc">
		<xs:annotation>
			<xs:documentation> Tipo da NF-e processada</xs:documentation>
		</xs:annotation>
		<xs:sequence>
			<xs:element name="NFe" type="TNFe"/>
			<xs:element name="protNFe" type="TProtNFe"/>
		</xs:sequence>
		<xs:attribute name="versao" type="TVerNFe" use="required"/>
	</xs:complexType>
	<xs:element name="nfeProc" type="TNfeProc">
		<xs:annotation>
			<xs:documentation> NF-e processada</xs:documentation>
		</xs:annotation>
	</xs:element>
</xs:schema>'