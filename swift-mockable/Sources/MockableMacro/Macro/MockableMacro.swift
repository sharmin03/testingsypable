import SwiftSyntax
import SwiftSyntaxMacros

public enum MockableMacro: PeerMacro {
    private static let extractor = Extractor()
    private static let mockGenerator = MockGenerator()

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let protocolDeclaration = try extractor.extractProtocolDeclaration(from: declaration)

        let mockClassDeclaration = mockGenerator.classDeclaration(for: protocolDeclaration)

        return [DeclSyntax(mockClassDeclaration)]
    }
}

