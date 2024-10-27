import Array "mo:base/Array";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Option "mo:base/Option";

actor {
    type Contact = {
        id: Nat;
        name: Text;
        phone: Text;
        email: Text;
    };

    private var nextId: Nat = 0;
    private var contacts = HashMap.HashMap<Nat, Contact>(0, Nat.equal, Hash.hash);

    public func createContact(name: Text, phone: Text, email: Text) : async Nat {
        let id = nextId;
        let newContact: Contact = {
            id;
            name;
            phone;
            email;
        };
        contacts.put(id, newContact);
        nextId += 1;
        id
    };

    public func updateContact(id: Nat, name: ?Text, phone: ?Text, email: ?Text) : async Bool {
        switch (contacts.get(id)) {
            case (null) { false };
            case (?existingContact) {
                let updatedContact: Contact = {
                    id = existingContact.id;
                    name = Option.get(name, existingContact.name);
                    phone = Option.get(phone, existingContact.phone);
                    email = Option.get(email, existingContact.email);
                };
                contacts.put(id, updatedContact);
                true
            };
        }
    };

    public query func getContact(id: Nat) : async ?Contact {
        contacts.get(id)
    };

    public query func getAllContacts() : async [Contact] {
        Iter.toArray(contacts.vals())
    };

    public func deleteContact(id: Nat) : async Bool {
        switch (contacts.remove(id)) {
            case (null) { false };
            case (?_) { true };
        }
    };
}
