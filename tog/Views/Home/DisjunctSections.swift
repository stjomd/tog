//
//  DisjunctSections.swift
//  tog
//
//  Created by Artem Zhukov on 15.08.21.
//

import SwiftUI

/// A wrapper for a section that groups its contents and the condition for it to be shown.
class DisjunctSection<SectionType> {
  @Binding var condition: Bool
  let content: SectionType
  /// Initializes this object.
  /// - parameters:
  ///   - condition: A binding to a boolean value that indicates if this section is to be presented.
  ///   - content: The list section.
  init(when condition: Binding<Bool>, _ content: () -> SectionType) {
    self._condition = condition
    self.content = content()
  }
}

/// A SwiftUI view that displays one of the several List Sections provided based on a condition.
///
/// This is how you can create a disjunct sections view that displays the second section:
/// ```
/// List {
///   DisjunctSections(sections: [
///     DisjunctSection(when: .constant(false)) {
///       Section {
///         Text("First Section")
///       }
///     },
///     DisjunctSection(when: .constant(true)) {
///       Section {
///         Text("Second Section")
///       }
///     }
///   ], otherwise: {
///     Section {
///       Text("Otherwise Section")
///     }
///   })
/// }
/// .listStyle(GroupedListStyle())
/// ```
/// Due to compiler limitations, this view currently only supports choosing between 6 (5 disjunct and 1 default) sections.
/// If you provide more sections, the excessive views are ignored and this view functions as if you had provided 6 sections.
struct DisjunctSections<Disjunct, Default>: View where Disjunct: View, Default: View {
  
  let sections: [DisjunctSection<Disjunct>]
  let main: Default
  
  private let count: Int
  
  var body: some View {
    // TODO: No loops supported in ViewBuilder unfortunately
    if 0 < count && sections[0].condition {
      sections[0].content
    } else if 1 < count && sections[1].condition {
      sections[1].content
    } else if 2 < count && sections[2].condition {
      sections[2].content
    } else if 3 < count && sections[3].condition {
      sections[3].content
    } else if 4 < count && sections[4].condition {
      sections[4].content
    } else {
      main
    }
  }
  
  /// Creates a view that displays one of the sections provided based on a condition, and a different section otherwise.
  ///
  /// Due to compiler limitations, up to 6 (5 disjunct and 1 default) sections are supported.
  /// If you provide more sections, the excessive views are ignored and this view functions as if you had provided 6 sections.
  init(sections: [DisjunctSection<Disjunct>], otherwise main: () -> Default) {
    self.sections = sections
    self.count = sections.count
    self.main = main()
  }
  
}

struct DisjunctSections_Previews: PreviewProvider {
  static var previews: some View {
    List {
      DisjunctSections(sections: [
        DisjunctSection(when: .constant(false)) {
          Section {
            Text("First Section")
          }
        },
        DisjunctSection(when: .constant(true)) {
          Section {
            Text("Second Section")
          }
        },
        DisjunctSection(when: .constant(false)) {
          Section {
            Text("Third Section")
          }
        }
      ], otherwise: {
        Section {
          Text("Otherwise Section")
        }
      })
    }
    .listStyle(InsetGroupedListStyle())
  }
}
